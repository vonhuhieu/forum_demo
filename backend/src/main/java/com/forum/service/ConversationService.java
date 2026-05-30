package com.forum.service;

import com.forum.dto.ConversationCreateDTO;
import com.forum.dto.ConversationDTO;
import com.forum.dto.ConversationDetailDTO;
import com.forum.dto.ConversationMessageDTO;
import com.forum.dto.UserDTO;
import com.forum.dto.ResponseDTO;
import com.forum.entity.Conversation;
import com.forum.entity.ConversationMessage;
import com.forum.entity.ConversationParticipant;
import com.forum.entity.User;
import com.forum.entity.Notification;
import com.forum.entity.NotificationType;
import com.forum.repository.ConversationMessageRepository;
import com.forum.repository.ConversationParticipantRepository;
import com.forum.repository.ConversationRepository;
import com.forum.repository.UserRepository;
import com.forum.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class ConversationService {

    private final UserRepository userRepository;
    private final ConversationRepository conversationRepository;
    private final ConversationParticipantRepository conversationParticipantRepository;
    private final ConversationMessageRepository conversationMessageRepository;
    private final SimpMessagingTemplate messagingTemplate;
    private final ReactionService reactionService;
    private final NotificationRepository notificationRepository;

    public ResponseDTO<ConversationDTO> createConversation(ConversationCreateDTO createDTO) {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        User sender = userRepository.findByUsername(currentUsername)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng hiện tại không hợp lệ"));

        // Tìm người nhận (hỗ trợ cả danh sách và chuỗi phân tách bằng dấu phẩy)
        List<String> rawNames = new ArrayList<>();
        if (createDTO.getRecipientDisplayNames() != null && !createDTO.getRecipientDisplayNames().isEmpty()) {
            rawNames.addAll(createDTO.getRecipientDisplayNames());
        } else if (createDTO.getRecipientDisplayName() != null && !createDTO.getRecipientDisplayName().trim().isEmpty()) {
            String[] parts = createDTO.getRecipientDisplayName().split(",");
            for (String part : parts) {
                if (!part.trim().isEmpty()) {
                    rawNames.add(part.trim());
                }
            }
        }

        if (rawNames.isEmpty()) {
            throw new IllegalArgumentException("Người nhận không được để trống");
        }

        List<User> recipients = new ArrayList<>();
        for (String rawName : rawNames) {
            String nameToFind = rawName.trim();
            if (nameToFind.isEmpty()) continue;

            Optional<User> recipientOpt = userRepository.findByUsername(nameToFind);
            if (recipientOpt.isEmpty()) {
                recipientOpt = userRepository.findAll().stream()
                        .filter(u -> u.getDisplayName() != null && u.getDisplayName().equalsIgnoreCase(nameToFind))
                        .findFirst();
            }

            User recipient = recipientOpt
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người nhận: " + nameToFind));

            if (sender.getId().equals(recipient.getId())) {
                throw new IllegalArgumentException("Bạn không thể đối thoại với chính mình");
            }

            if (!recipients.contains(recipient)) {
                recipients.add(recipient);
            }
        }

        if (recipients.isEmpty()) {
            throw new IllegalArgumentException("Người nhận không được để trống");
        }

        if (createDTO.getTitle() == null || createDTO.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề không được để trống");
        }
        if (createDTO.getContent() == null || createDTO.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống");
        }

        // Tạo Conversation
        Conversation conversation = new Conversation();
        conversation.setTitle(createDTO.getTitle().trim());
        conversation.setCreator(sender);
        conversation = conversationRepository.save(conversation);

        // Tạo Participants
        List<ConversationParticipant> participantsToSave = new ArrayList<>();

        ConversationParticipant senderPart = new ConversationParticipant();
        senderPart.setConversation(conversation);
        senderPart.setUser(sender);
        senderPart.setRead(false); // Người gửi chưa đọc (hiển thị thông báo chưa đọc cho chính người tạo)
        participantsToSave.add(senderPart);

        for (User recipient : recipients) {
            ConversationParticipant recipientPart = new ConversationParticipant();
            recipientPart.setConversation(conversation);
            recipientPart.setUser(recipient);
            recipientPart.setRead(false); // Người nhận chưa đọc
            participantsToSave.add(recipientPart);
        }

        conversationParticipantRepository.saveAll(participantsToSave);

        // Tạo Message
        ConversationMessage message = new ConversationMessage();
        message.setConversation(conversation);
        message.setSender(sender);
        message.setContent(createDTO.getContent());
        conversationMessageRepository.save(message);

        // Chuẩn bị danh sách người tham gia hiển thị
        List<String> participantNames = new ArrayList<>();
        participantNames.add(sender.getDisplayName() != null ? sender.getDisplayName() : sender.getUsername());
        for (User recipient : recipients) {
            participantNames.add(recipient.getDisplayName() != null ? recipient.getDisplayName() : recipient.getUsername());
        }

        // PUSH WebSocket: Tạo DTO tương ứng với trạng thái đọc của mỗi bên
        ConversationDTO senderDTO = new ConversationDTO();
        senderDTO.setId(conversation.getId());
        senderDTO.setTitle(conversation.getTitle());
        senderDTO.setParticipants(participantNames);
        senderDTO.setUpdatedAt(conversation.getUpdatedAt());
        senderDTO.setCreatorAvatar(sender.getAvatar());
        senderDTO.setCreatorUsername(sender.getUsername());
        senderDTO.setCreatorDisplayName(sender.getDisplayName());
        senderDTO.setFirstMessageId(message.getId());
        senderDTO.setRead(false);

        // PUSH to sender
        pushToUser(sender.getId(), senderDTO);

        // PUSH to all recipients
        for (User recipient : recipients) {
            ConversationDTO recipientDTO = new ConversationDTO();
            recipientDTO.setId(conversation.getId());
            recipientDTO.setTitle(conversation.getTitle());
            recipientDTO.setParticipants(participantNames);
            recipientDTO.setUpdatedAt(conversation.getUpdatedAt());
            recipientDTO.setCreatorAvatar(sender.getAvatar());
            recipientDTO.setCreatorUsername(sender.getUsername());
            recipientDTO.setCreatorDisplayName(sender.getDisplayName());
            recipientDTO.setFirstMessageId(message.getId());
            recipientDTO.setRead(false);

            pushToUser(recipient.getId(), recipientDTO);
        }

        return ResponseDTO.success(senderDTO);
    }

    private void pushToUser(Long userId, ConversationDTO dto) {
        try {
            String dest = "/topic/conversations/" + userId;
            messagingTemplate.convertAndSend(dest, dto);
            log.info("WebSocket pushed conversation to: {}", dest);
        } catch (Exception e) {
            log.warn("Failed to push websocket conversation message to user: {}, error: {}", userId, e.getMessage());
        }
    }

    public ResponseDTO<List<ConversationDTO>> getMyConversations() {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        List<Conversation> conversations = conversationRepository.findMyConversations(currentUsername);

        List<ConversationDTO> dtos = conversations.stream().map(c -> {
            ConversationDTO dto = new ConversationDTO();
            dto.setId(c.getId());
            dto.setTitle(c.getTitle());
            dto.setUpdatedAt(c.getCreatedAt());
            dto.setCreatorAvatar(c.getCreator().getAvatar());
            dto.setCreatorUsername(c.getCreator().getUsername());
            dto.setCreatorDisplayName(c.getCreator().getDisplayName());
            
            conversationMessageRepository.findFirstByConversationIdOrderByCreatedAtAsc(c.getId())
                    .map(ConversationMessage::getId)
                    .ifPresent(dto::setFirstMessageId);

            // Tìm trạng thái read của user hiện tại
            boolean isRead = c.getParticipants().stream()
                    .filter(p -> p.getUser().getUsername().equals(currentUsername))
                    .map(ConversationParticipant::isRead)
                    .findFirst()
                    .orElse(true);
            dto.setRead(isRead);

            // Gồm cả người tham gia
            List<String> parts = c.getParticipants().stream()
                    .map(p -> p.getUser().getDisplayName() != null ? p.getUser().getDisplayName() : p.getUser().getUsername())
                    .collect(Collectors.toList());
            dto.setParticipants(parts);
            dto.setReply(false);

            return dto;
        }).collect(Collectors.toList());

        List<Notification> conversationNotifs = notificationRepository.findByRecipientUsernameAndTypeInOrderByCreatedAtDesc(
            currentUsername, 
            List.of(NotificationType.CONVERSATION_REACTION, NotificationType.CONVERSATION_REPLY, NotificationType.CONVERSATION_QUOTE)
        );
        List<ConversationDTO> notifDtos = conversationNotifs.stream().map(n -> {
            ConversationDTO dto = new ConversationDTO();
            if (n.getConversation() != null) {
                dto.setId(n.getConversation().getId());
                dto.setTitle(n.getConversation().getTitle());
            }
            if (n.getConversationMessage() != null) {
                dto.setFirstMessageId(n.getConversationMessage().getId());
            }
            dto.setUpdatedAt(n.getCreatedAt());
            if (n.getActor() != null) {
                dto.setCreatorAvatar(n.getActor().getAvatar());
                dto.setCreatorUsername(n.getActor().getUsername());
                dto.setCreatorDisplayName(n.getActor().getDisplayName());
            }
            dto.setRead(n.isRead());
            dto.setNotificationId(n.getId());

            if (n.getType() == NotificationType.CONVERSATION_REACTION) {
                dto.setReaction(true);
                dto.setReactionIcon(n.getReactionIcon());
                dto.setReactionName(n.getReactionName());
                dto.setReactionColor(n.getReactionColor());
            } else if (n.getType() == NotificationType.CONVERSATION_REPLY) {
                dto.setReply(true);
                dto.setLastMessageSenderUsername(n.getActor() != null ? n.getActor().getUsername() : null);
                dto.setLastMessageSenderDisplayName(n.getActor() != null ? n.getActor().getDisplayName() : null);
                dto.setLastMessageSenderAvatar(n.getActor() != null ? n.getActor().getAvatar() : null);
                dto.setLastMessageId(n.getConversationMessage() != null ? n.getConversationMessage().getId() : null);
            } else if (n.getType() == NotificationType.CONVERSATION_QUOTE) {
                dto.setQuote(true);
                dto.setLastMessageSenderUsername(n.getActor() != null ? n.getActor().getUsername() : null);
                dto.setLastMessageSenderDisplayName(n.getActor() != null ? n.getActor().getDisplayName() : null);
                dto.setLastMessageSenderAvatar(n.getActor() != null ? n.getActor().getAvatar() : null);
                dto.setLastMessageId(n.getConversationMessage() != null ? n.getConversationMessage().getId() : null);
            }
            
            return dto;
        }).collect(Collectors.toList());

        List<ConversationDTO> merged = new java.util.ArrayList<>();
        merged.addAll(dtos);
        merged.addAll(notifDtos);
        
        merged.sort((a, b) -> b.getUpdatedAt().compareTo(a.getUpdatedAt()));

        return ResponseDTO.success(merged);
    }

    public ResponseDTO<Long> getMyUnreadCount() {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        long unreadCount = conversationParticipantRepository.countByUserUsernameAndIsReadFalse(currentUsername);
        long unreadNotifs = notificationRepository.countByRecipientUsernameAndTypeInAndIsReadFalse(currentUsername, List.of(NotificationType.CONVERSATION_REACTION, NotificationType.CONVERSATION_REPLY, NotificationType.CONVERSATION_QUOTE));
        return ResponseDTO.success(unreadCount + unreadNotifs);
    }

    public ResponseDTO<Void> readAll() {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        List<ConversationParticipant> unreads = conversationParticipantRepository.findByUserUsername(currentUsername)
                .stream().filter(p -> !p.isRead()).collect(Collectors.toList());

        unreads.forEach(p -> {
            p.setRead(true);
            conversationParticipantRepository.save(p);
        });

        return ResponseDTO.success(null);
    }

    public ResponseDTO<Void> markAsRead(Long id) {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Conversation convo = conversationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Hội thoại không tồn tại"));

        ConversationParticipant participant = convo.getParticipants().stream()
                .filter(p -> p.getUser().getUsername().equals(currentUsername))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Bạn không tham gia cuộc hội thoại này"));

        if (!participant.isRead()) {
            participant.setRead(true);
            conversationParticipantRepository.save(participant);
        }

        notificationRepository.markConversationNotificationsAsRead(currentUsername, id);

        return ResponseDTO.success(null);
    }

    public ResponseDTO<ConversationDetailDTO> getConversationDetail(Long id) {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Conversation convo = conversationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Hội thoại không tồn tại"));

        Optional<ConversationParticipant> currentPartOpt = convo.getParticipants().stream()
                .filter(p -> p.getUser().getUsername().equals(currentUsername))
                .findFirst();
        if (currentPartOpt.isEmpty()) {
            throw new IllegalArgumentException("Bạn không có quyền tham gia cuộc hội thoại này");
        }

        ConversationParticipant currentPart = currentPartOpt.get();
        // Chỉ tự động đánh dấu đã đọc nếu người đang xem KHÔNG phải là người tạo cuộc hội thoại
        if (!currentPart.isRead() && !convo.getCreator().getUsername().equals(currentUsername)) {
            currentPart.setRead(true);
            conversationParticipantRepository.save(currentPart);
        }

        notificationRepository.markConversationNotificationsAsRead(currentUsername, id);

        ConversationDetailDTO dto = new ConversationDetailDTO();
        dto.setId(convo.getId());
        dto.setTitle(convo.getTitle());
        dto.setCreator(mapUserToDTO(convo.getCreator()));
        dto.setCreatedAt(convo.getCreatedAt());
        dto.setUpdatedAt(convo.getUpdatedAt());

        List<UserDTO> participantDTOs = convo.getParticipants().stream()
                .map(p -> mapUserToDTO(p.getUser()))
                .collect(Collectors.toList());
        dto.setParticipants(participantDTOs);
        dto.setParticipantCount(participantDTOs.size());

        List<ConversationMessageDTO> messageDTOs = convo.getMessages().stream()
                .map(m -> {
                    ConversationMessageDTO mDto = new ConversationMessageDTO();
                    mDto.setId(m.getId());
                    mDto.setContent(m.getContent());
                    mDto.setSender(mapUserToDTO(m.getSender()));
                    mDto.setCreatedAt(m.getCreatedAt());
                    mDto.setReactionSummary(reactionService.getSummaryForMessage(m.getId()));
                    mDto.setCurrentUserReaction(reactionService.getCurrentUserReactionForMessage(m.getId()));
                    mDto.setRecentReactors(reactionService.getRecentReactorsForMessage(m.getId()));
                    return mDto;
                })
                .collect(Collectors.toList());
        dto.setMessages(messageDTOs);
        dto.setReplyCount(messageDTOs.size());

        if (!messageDTOs.isEmpty()) {
            ConversationMessageDTO lastMsg = messageDTOs.get(messageDTOs.size() - 1);
            dto.setLastReplyAt(lastMsg.getCreatedAt());
            dto.setLastReplyAuthor(lastMsg.getSender());
        }

        return ResponseDTO.success(dto);
    }

    public ResponseDTO<ConversationMessageDTO> addMessage(Long conversationId, String content, Long quotedMessageId) {
        String currentUsername = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        User currentUser = userRepository.findByUsername(currentUsername)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không hợp lệ"));
        Conversation convo = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new IllegalArgumentException("Hội thoại không tồn tại"));

        boolean isParticipant = convo.getParticipants().stream()
                .anyMatch(p -> p.getUser().getUsername().equals(currentUsername));
        if (!isParticipant) {
            throw new IllegalArgumentException("Bạn không có quyền tham gia cuộc hội thoại này");
        }

        ConversationMessage message = new ConversationMessage();
        message.setConversation(convo);
        message.setSender(currentUser);
        message.setContent(content);
        ConversationMessage savedMsg = conversationMessageRepository.save(message);

        convo.setUpdatedAt(java.time.LocalDateTime.now());
        conversationRepository.save(convo);

        // Tìm xem có người dùng bị trích dẫn (quote) không
        User quotedUser = null;
        if (quotedMessageId != null) {
            quotedUser = conversationMessageRepository.findById(quotedMessageId)
                    .map(ConversationMessage::getSender)
                    .orElse(null);
        }

        // Lưu thông báo phản hồi đối thoại cho tất cả người tham gia và push
        for (ConversationParticipant p : convo.getParticipants()) {
            Notification notif = new Notification();
            notif.setRecipient(p.getUser());
            notif.setActor(currentUser);
            
            boolean isQuoteNotif = quotedUser != null 
                    && p.getUser().getId().equals(quotedUser.getId()) 
                    && !p.getUser().getId().equals(currentUser.getId());

            if (isQuoteNotif) {
                notif.setType(NotificationType.CONVERSATION_QUOTE);
            } else {
                notif.setType(NotificationType.CONVERSATION_REPLY);
            }
            
            notif.setConversation(convo);
            notif.setConversationMessage(savedMsg);
            notif.setRead(false);
            
            Notification savedNotif = notificationRepository.save(notif);

            ConversationDTO replyDTO = new ConversationDTO();
            replyDTO.setId(convo.getId());
            replyDTO.setTitle(convo.getTitle());
            replyDTO.setFirstMessageId(savedMsg.getId()); // ID tin nhắn phản hồi
            replyDTO.setUpdatedAt(savedNotif.getCreatedAt());
            replyDTO.setCreatorAvatar(currentUser.getAvatar());
            replyDTO.setCreatorUsername(currentUser.getUsername());
            replyDTO.setCreatorDisplayName(currentUser.getDisplayName());
            replyDTO.setRead(false);
            
            if (savedNotif.getType() == NotificationType.CONVERSATION_QUOTE) {
                replyDTO.setQuote(true);
            } else {
                replyDTO.setReply(true);
            }
            replyDTO.setNotificationId(savedNotif.getId());
            replyDTO.setLastMessageSenderUsername(currentUser.getUsername());
            replyDTO.setLastMessageSenderDisplayName(currentUser.getDisplayName());
            replyDTO.setLastMessageSenderAvatar(currentUser.getAvatar());
            replyDTO.setLastMessageId(savedMsg.getId());

            pushToUser(p.getUser().getId(), replyDTO);
        }

        ConversationMessageDTO mDto = new ConversationMessageDTO();
        mDto.setId(savedMsg.getId());
        mDto.setContent(savedMsg.getContent());
        mDto.setSender(mapUserToDTO(savedMsg.getSender()));
        mDto.setCreatedAt(savedMsg.getCreatedAt());

        try {
            String dest = "/topic/conversations/" + conversationId + "/messages";
            messagingTemplate.convertAndSend(dest, mDto);
            log.info("WebSocket pushed conversation message to: {}", dest);
        } catch (Exception e) {
            log.warn("Failed to push websocket message to topic: {}, error: {}", conversationId, e.getMessage());
        }

        return ResponseDTO.success(mDto);
    }

    private UserDTO mapUserToDTO(User user) {
        if (user == null) return null;
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setDisplayName(user.getDisplayName());
        dto.setEmail(user.getEmail());
        dto.setAvatar(user.getAvatar());
        dto.setCreatedAt(user.getCreatedAt());
        dto.setRoles(user.getRoles());
        return dto;
    }
}
