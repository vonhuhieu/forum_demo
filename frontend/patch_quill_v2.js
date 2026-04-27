const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'node_modules', 'quill-better-table', 'dist', 'quill-better-table.js');

if (!fs.existsSync(filePath)) {
  console.error('File not found:', filePath);
  process.exit(1);
}

let content = fs.readFileSync(filePath, 'utf8');

console.log('Applying Quill 2.0 compatibility patches...');

// 1. Fix matchTableCell and matchTableHeader (null check for table)
content = content.replace(
  /const table = node\.closest\('table'\)/g,
  "const table = node.closest('table'); if (!table) return delta;"
);

// 2. Fix infinite loops in optimize() by replacing instanceof with blotName check
// This is critical for Quill 2.0/Parchment 2.0
content = content.replace(
  /this\.parent instanceof TableCell\)/g,
  "this.parent && this.parent.statics.blotName === 'table-cell')"
);
content = content.replace(
  /this\.parent instanceof TableRow\)/g,
  "this.parent && this.parent.statics.blotName === 'table-row')"
);
content = content.replace(
  /child instanceof TableCell\)/g,
  "child && child.statics.blotName === 'table-cell')"
);

// 3. Fix checkMerge()
content = content.replace(
  /const isNextTableCell = next instanceof TableCell/g,
  "const isNextTableCell = next && next.statics.blotName === 'table-cell'"
);
content = content.replace(
  /const isNextTableRow = next instanceof TableRow/g,
  "const isNextTableRow = next && next.statics.blotName === 'table-row'"
);

// 4. Aggressive safety for attributes access
content = content.replace(/op\.attributes\.([a-zA-Z0-9_-]+)/g, (match, prop) => {
  if (match.includes('&&')) return match; // Already patched
  return `(op.attributes && op.attributes.${prop})`;
});

// 5. Ensure op.attributes is not null/undefined
content = content.replace(/insert\(([^,]+),\s*op\.attributes\)/g, "insert($1, op.attributes || {})");
content = content.replace(/_omit\(op\.attributes,/g, "_omit(op.attributes || {},");

fs.writeFileSync(filePath, content, 'utf8');
console.log('Successfully applied all patches to quill-better-table.js');
