const PT_TO_LOGICAL_PIXELS = 1.33;

class TableMatrix {
  constructor() {
    this.slots = [];
    this.placements = [];
    this.numRows = 0;
    this.numCols = 0;
  }

  ensureSize(rows, cols) {
    while (this.slots.length < rows) this.slots.push([]);
    for (let r = 0; r < rows; r++) {
      while (this.slots[r].length < cols) this.slots[r].push(null);
    }
    this.numRows = Math.max(this.numRows, rows);
    this.numCols = Math.max(this.numCols, cols);
  }

  isOccupied(row, col) {
    if (row >= this.slots.length) return false;
    if (col >= this.slots[row].length) return false;
    return this.slots[row][col] !== null;
  }

  findFreeColumn(row, startCol) {
    this.ensureSize(row + 1, startCol + 1);
    let col = startCol;
    while (this.isOccupied(row, col)) {
      col++;
      this.ensureSize(row + 1, col + 1);
    }
    return col;
  }

  occupy(row, col, rowspan, colspan, placementIdx) {
    const endRow = row + rowspan;
    const endCol = col + colspan;
    this.ensureSize(endRow, endCol);
    for (let r = row; r < endRow; r++) {
      for (let c = col; c < endCol; c++) {
        this.slots[r][c] = { placementIdx, originRow: row, originCol: col, rowspan, colspan };
      }
    }
    this.numCols = Math.max(this.numCols, endCol);
  }

  addPlacement(placement) {
    const idx = this.placements.length;
    this.placements.push(placement);
    return idx;
  }

  toMatrixData() {
    const data = [];
    for (let r = 0; r < this.numRows; r++) {
      const row = [];
      for (let c = 0; c < this.numCols; c++) {
        const slot = this.slots[r]?.[c];
        row.push(slot !== null && slot !== undefined ? slot.placementIdx : -1);
      }
      data.push(row);
    }
    return data;
  }
}

class TableStyleContext {
  constructor(opts = {}) {
    this.bgColor       = opts.bgColor       || null;
    this.bgGradient    = opts.bgGradient    || null;   // {direction, color, percent} from linear-gradient
    this.textColor     = opts.textColor     || null;
    this.fontWeight    = opts.fontWeight    || null;
    this.fontStyle     = opts.fontStyle     || null;   // 'FontStyle.italic'
    this.fontFamily    = opts.fontFamily    || null;
    this.fontSize      = opts.fontSize      || null;
    this.textDecoration= opts.textDecoration|| null;   // 'TextDecoration.underline' etc.
    this.textDecorationStyle = opts.textDecorationStyle || null; // 'TextDecorationStyle.double' etc.
    this.textAlign     = opts.textAlign     || 'left';
    this.verticalAlign = opts.verticalAlign || 'middle';
    this.rotateAngle   = opts.rotateAngle   || null;   // degrees (number)
    this.whiteSpace    = opts.whiteSpace    || null;
    this.lineHeight    = opts.lineHeight    || null;   // Flutter TextStyle.height ratio (line-height / font-size)
    this.cellBorder    = opts.cellBorder    || null;   // Flutter Border() string
    this.textTransform = opts.textTransform || null;   // 'uppercase', 'lowercase', 'capitalize'
    // Raw CSS values for JSON output (avoids parsing Flutter strings back)
    this.rawBgColor    = opts.rawBgColor    || null;
    this.rawTextColor  = opts.rawTextColor  || null;
    this.rawBorderCss  = opts.rawBorderCss  || null;   // raw CSS border properties
  }

  copyWith(opts) {
    return new TableStyleContext({
      bgColor:             opts.bgColor             ?? this.bgColor,
      bgGradient:          opts.bgGradient          ?? this.bgGradient,
      textColor:           opts.textColor           ?? this.textColor,
      fontWeight:          opts.fontWeight          ?? this.fontWeight,
      fontStyle:           opts.fontStyle           ?? this.fontStyle,
      fontFamily:          opts.fontFamily          ?? this.fontFamily,
      fontSize:            opts.fontSize            ?? this.fontSize,
      textDecoration:      opts.textDecoration      ?? this.textDecoration,
      textDecorationStyle: opts.textDecorationStyle ?? this.textDecorationStyle,
      textAlign:           opts.textAlign           ?? this.textAlign,
      verticalAlign:       opts.verticalAlign       ?? this.verticalAlign,
      rotateAngle:         opts.rotateAngle         ?? this.rotateAngle,
      whiteSpace:          opts.whiteSpace          ?? this.whiteSpace,
      lineHeight:          opts.lineHeight          ?? this.lineHeight,
      cellBorder:          'cellBorder' in opts      ? opts.cellBorder : this.cellBorder,
      textTransform:       opts.textTransform       ?? this.textTransform,
      rawBgColor:          opts.rawBgColor          ?? this.rawBgColor,
      rawTextColor:        opts.rawTextColor        ?? this.rawTextColor,
      rawBorderCss:        opts.rawBorderCss        ?? this.rawBorderCss,
    });
  }
}

const TableHandler = {
  generate(node, context, inheritedStyles = null) {
    const estimatedWidth = context.containerWidth || null;
    const result = this.buildTable(node, inheritedStyles, estimatedWidth);
    return this.render(node, result, context, inheritedStyles);
  },

  convertDimension(dim) {
    if (!dim) return null;
    if (dim.unit === 'pt') return { value: dim.value * PT_TO_LOGICAL_PIXELS, unit: 'px' };
    return dim;
  },

  buildTable(tableNode, parentStyle, estimatedAvailableWidth = null) {
    const allRows = this.collectRows(tableNode);
    const numRows = allRows.length;
    if (numRows === 0) return { matrix: new TableMatrix(), rowData: [], columnWidths: [], minRowHeights: [] };

    // Resolve inherited base styles: body/parent first, then table's own styles override
    const baseOpts = {};
    if (parentStyle) {
      if (parentStyle.fontSize) {
        const dim = this.convertDimension(StyleParser.parseDimension(parentStyle.fontSize));
        if (dim) baseOpts.fontSize = dim.value;
      }
      if (parentStyle.fontFamily) {
        const ff = parentStyle.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
        if (ff) baseOpts.fontFamily = ff;
      }
      if (parentStyle.color) baseOpts.textColor = StyleParser.colorToFlutter(parentStyle.color);
    }
    // Table's own font-size / font-family / color override body defaults
    if (tableNode.styles?.fontSize) {
      const dim = this.convertDimension(StyleParser.parseDimension(tableNode.styles.fontSize));
      if (dim) baseOpts.fontSize = dim.value;
    }
    if (tableNode.styles?.fontFamily) {
      const ff = tableNode.styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
      if (ff) baseOpts.fontFamily = ff;
    }
    if (tableNode.styles?.color) baseOpts.textColor = StyleParser.colorToFlutter(tableNode.styles.color);

    const matrix = new TableMatrix();
    matrix.numRows = numRows;
    // Pre-compute colgroup column count to clamp excess cells from Luckysheet rowspan artifacts
    const _colgroups = this.collectColgroups(tableNode);
    const _colgroupCols = this.countColgroupColumns(_colgroups);
    const maxCols = _colgroupCols > 0 ? _colgroupCols : Infinity;
    const rowData = [];
    const minRowHeights = [];
    const cellHeightMap = new Map(); // cell → {effFontSize, structuralLines}

    for (let rowIdx = 0; rowIdx < numRows; rowIdx++) {
      const row = allRows[rowIdx];
      let sectionStyle = new TableStyleContext(baseOpts);
      if (row.sectionType === 'thead') {
        sectionStyle = sectionStyle.copyWith({ bgColor: 'Colors.grey.shade200', fontWeight: 'FontWeight.bold', rawBgColor: '#EEEEEE' });
      }

      let rowStyle = sectionStyle;
      if (row.node?.bgcolor) rowStyle = rowStyle.copyWith({ bgColor: StyleParser.colorToFlutter(row.node.bgcolor), rawBgColor: row.node.bgcolor });
      if (row.node?.styles?.backgroundColor) rowStyle = rowStyle.copyWith({ bgColor: StyleParser.colorToFlutter(row.node.styles.backgroundColor), rawBgColor: row.node.styles.backgroundColor });

      // Apply <tr> text styles so cells inherit them
      const trStyles = row.node?.styles || {};
      if (trStyles.fontSize) {
        const dim = this.convertDimension(StyleParser.parseDimension(trStyles.fontSize));
        if (dim) rowStyle = rowStyle.copyWith({ fontSize: dim.value });
      }
      if (trStyles.fontWeight) {
        const fw = StyleParser.fontWeightToFlutter(trStyles.fontWeight);
        if (fw) rowStyle = rowStyle.copyWith({ fontWeight: fw });
      }
      if (trStyles.fontStyle === 'italic') rowStyle = rowStyle.copyWith({ fontStyle: 'FontStyle.italic' });
      if (trStyles.fontFamily) {
        const ff = trStyles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
        if (ff) rowStyle = rowStyle.copyWith({ fontFamily: ff });
      }
      if (trStyles.color) rowStyle = rowStyle.copyWith({ textColor: StyleParser.colorToFlutter(trStyles.color) });
      if (trStyles.lineHeight) {
        const ratio = this.resolveLineHeightRatio(trStyles.lineHeight, rowStyle.fontSize || baseOpts.fontSize || 12);
        if (ratio) rowStyle = rowStyle.copyWith({ lineHeight: ratio });
      }

      // Compute per-cell height and take the max across the row
      const cellPadDefault = this.getPadding(tableNode);
      const rowFontSize = rowStyle.fontSize || baseOpts.fontSize || 16;
      const blockTagsH = new Set(['div','p','h1','h2','h3','h4','h5','h6','ul','ol']);
      let maxCellHeight = 0;
      let maxTextCellHeight = 0;  // text content only (excludes widget estimates)

      for (const cell of row.cells) {
        // Effective font size: use cell's own fontSize if set, otherwise row/body default
        let effFontSize = rowFontSize;
        if (cell.styles?.fontSize) {
          const d = this.convertDimension(StyleParser.parseDimension(cell.styles.fontSize));
          if (d) effFontSize = d.value;
        }

        const pt = cell.styles?.paddingTop    ? (this.convertDimension(StyleParser.parseDimension(cell.styles.paddingTop))?.value    ?? cellPadDefault) : cellPadDefault;
        const pb = cell.styles?.paddingBottom ? (this.convertDimension(StyleParser.parseDimension(cell.styles.paddingBottom))?.value ?? cellPadDefault) : cellPadDefault;
        const bt = cell.styles?.borderTopWidth    ? (StyleParser.parseDimension(cell.styles.borderTopWidth)?.value    ?? 0) : 0;
        const bb = cell.styles?.borderBottomWidth ? (StyleParser.parseDimension(cell.styles.borderBottomWidth)?.value ?? 0) : 0;

        // Compute content height by summing per-block-child heights.
        // Block children with their own font-size use that size, not the inherited size.
        // Inline content uses cell's effFontSize.
        let totalContentH = 0;
        let hasCurrentInline = false;
        let maxChildFs = effFontSize;   // track largest child font for refineRowHeights
        let widgetContentH = 0;         // minimum height from form widgets
        for (const child of (cell.children || [])) {
          if (blockTagsH.has(child.tagName)) {
            if (hasCurrentInline) {
              totalContentH += Math.ceil(effFontSize * 1.5);
              hasCurrentInline = false;
            }
            // Use child's own font-size if specified
            let childFs = effFontSize;
            if (child.styles?.fontSize) {
              const d = this.convertDimension(StyleParser.parseDimension(child.styles.fontSize));
              if (d) childFs = d.value;
            }
            totalContentH += Math.ceil(childFs * 1.5);
            if (childFs > maxChildFs) maxChildFs = childFs;
          } else if (child.tagName === 'br') {
            if (hasCurrentInline) {
              totalContentH += Math.ceil(effFontSize * 1.5);
              hasCurrentInline = false;
            }
          } else if (child.type === 'textarea') {
            if (hasCurrentInline) { totalContentH += Math.ceil(effFontSize * 1.5); hasCurrentInline = false; }
            // rows * lineHeight + contentPadding(8+8) + border(1+1)
            widgetContentH = Math.max(widgetContentH, Math.ceil((child.rows || 3) * effFontSize * 1.5) + 18);
          } else if (child.type === 'input' || child.type === 'date-picker') {
            // fontSize + contentPadding(8+8) + border(1+1)
            widgetContentH = Math.max(widgetContentH, Math.ceil(effFontSize + 18));
          } else if (child.type === 'select') {
            widgetContentH = Math.max(widgetContentH, Math.ceil(effFontSize * 1.5 + 8));
          } else if (child.type === 'signature' || child.type === 'image-upload') {
            // Use explicit height if set, else default
            let wh = child.type === 'signature' ? 100 : 150;
            if (child.height) { const d = StyleParser.parseDimension(child.height); if (d) wh = d.value; }
            widgetContentH = Math.max(widgetContentH, wh);
          } else if (child.type === 'table') {
          if (hasCurrentInline) { totalContentH += Math.ceil(effFontSize * 1.5); hasCurrentInline = false; }
            // Calculate cell's pixel width from parent table's estimatedAvailableWidth + cell width attribute
            let nestedEstW = null;
            if (estimatedAvailableWidth != null) {
              const cellWidthStr = cell.width || cell.styles?.width;
              if (cellWidthStr) {
                const d = this.convertDimension(StyleParser.parseDimension(cellWidthStr));
                if (d && d.unit === '%') nestedEstW = estimatedAvailableWidth * (d.value / 100);
                else if (d) nestedEstW = d.value;
              } else {
                nestedEstW = estimatedAvailableWidth;
              }
            }
            const nested = this.buildTable(child, null, nestedEstW);
            const nestedH = nested.minRowHeights.reduce((a, b) => a + b, 0);
            totalContentH += Math.max(nestedH, Math.ceil(effFontSize * 1.5));
          }
          else if ((child.type === 'text' && child.content?.trim()) || (child.tagName && child.tagName !== 'svg')) {
            hasCurrentInline = true;
          }
        }
        if (hasCurrentInline) {
          // For pre/pre-wrap/pre-line cells, count explicit newlines as additional lines.
          const preWrap = ['pre', 'pre-wrap', 'pre-line'].includes(cell.styles?.whiteSpace);
          if (preWrap) {
            const rawText = this.extractTextPreserveNewlines(cell);
            const lineCount = Math.max(1, rawText.split('\n').length);
            totalContentH += Math.ceil(effFontSize * 1.5) * lineCount;
          } else {
            totalContentH += Math.ceil(effFontSize * 1.5);
          }
        }
        if (totalContentH === 0 && widgetContentH === 0) totalContentH = Math.ceil(effFontSize * 1.5);

        // structuralLines: how many lines at maxChildFs (for refineRowHeights wrapping estimate)
        const structuralLines = Math.max(1, Math.round(totalContentH / Math.ceil(maxChildFs * 1.5)));
        cellHeightMap.set(cell, { effFontSize: maxChildFs, structuralLines });

        const contentH = Math.max(totalContentH, widgetContentH);
        const cellH    = contentH + pt + pb + bt + bb;
        maxCellHeight = Math.max(maxCellHeight, cellH);

        const textCellH = totalContentH + pt + pb + bt + bb;
        maxTextCellHeight = Math.max(maxTextCellHeight, textCellH);
      }

      // Determine explicit row height from <tr style="height:"> or cell height attrs
      let explicitRowH = null;
      if (row.node?.styles?.height) {
        const dim = this.convertDimension(StyleParser.parseDimension(row.node.styles.height));
        if (dim && dim.unit !== '%') explicitRowH = dim.value;
      } else {
        for (const cell of row.cells) {
          const hStr = cell.styles?.height || cell.height;
          if (hStr) {
            const dim = this.convertDimension(StyleParser.parseDimension(hStr));
            if (dim && dim.unit !== '%') explicitRowH = Math.max(explicitRowH || 0, dim.value);
          }
        }
      }

      let minHeight;
      if (explicitRowH != null) {
        // When row has explicit height: use max of explicit height and text content height.
        // Widget estimates (textarea, signature, etc.) are excluded — they inflated heights
        // far beyond what the HTML author intended.
        minHeight = Math.max(maxTextCellHeight, explicitRowH, 20);
      } else {
        // No explicit height: use full content height including widgets.
        minHeight = Math.max(maxCellHeight, 20);
      }
      minRowHeights.push(minHeight);
      rowData.push({ ...row, style: rowStyle });

      let colIdx = 0;
      for (const cell of row.cells) {
        colIdx = matrix.findFreeColumn(rowIdx, colIdx);
        if (colIdx >= maxCols) break; // skip excess cells beyond colgroup columns
        const colspan = Math.min(cell.colspan || 1, maxCols - colIdx);
        const rawRowspan = cell.rowspan || 1;
        const rowspan = Math.min(rawRowspan, numRows - rowIdx);

        let cellStyle = rowStyle;

        if (cell.bgcolor) cellStyle = cellStyle.copyWith({ bgColor: StyleParser.colorToFlutter(cell.bgcolor), rawBgColor: cell.bgcolor });
        if (cell.styles?.backgroundColor) cellStyle = cellStyle.copyWith({ bgColor: StyleParser.colorToFlutter(cell.styles.backgroundColor), rawBgColor: cell.styles.backgroundColor });
        // Linear-gradient background (Luckysheet dataBar)
        if (cell.styles?.backgroundGradient) cellStyle = cellStyle.copyWith({ bgGradient: cell.styles.backgroundGradient });

        if (cell.type === 'th' || cell.isHeader) cellStyle = cellStyle.copyWith({ fontWeight: 'FontWeight.bold' });

        if (cell.styles?.fontWeight) {
          const fw = StyleParser.fontWeightToFlutter(cell.styles.fontWeight);
          if (fw) cellStyle = cellStyle.copyWith({ fontWeight: fw });
        }

        if (cell.styles?.fontStyle === 'italic') cellStyle = cellStyle.copyWith({ fontStyle: 'FontStyle.italic' });

        // Font family — strip quotes, take first family
        if (cell.styles?.fontFamily) {
          const ff = cell.styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
          if (ff) cellStyle = cellStyle.copyWith({ fontFamily: ff });
        }

        if (cell.styles?.color) cellStyle = cellStyle.copyWith({ textColor: StyleParser.colorToFlutter(cell.styles.color), rawTextColor: cell.styles.color });

        // Font size — parseDimension converts pt→px
        if (cell.styles?.fontSize) {
          const dim = this.convertDimension(StyleParser.parseDimension(cell.styles.fontSize));
          if (dim) cellStyle = cellStyle.copyWith({ fontSize: dim.value });
        }

        if (cell.styles?.lineHeight) {
          const ratio = this.resolveLineHeightRatio(cell.styles.lineHeight, cellStyle.fontSize || baseOpts.fontSize || 12);
          if (ratio) cellStyle = cellStyle.copyWith({ lineHeight: ratio });
        }

        if (cell.styles?.textDecoration) {
          const td  = StyleParser.textDecorationToFlutter(cell.styles.textDecoration);
          const tds = StyleParser.textDecorationStyleToFlutter(cell.styles.textDecoration);
          if (td)  cellStyle = cellStyle.copyWith({ textDecoration: td });
          if (tds) cellStyle = cellStyle.copyWith({ textDecorationStyle: tds });
        }

        if (cell.align || cell.styles?.textAlign) {
          cellStyle = cellStyle.copyWith({ textAlign: cell.align || cell.styles.textAlign });
        }
        if (cell.valign || cell.styles?.verticalAlign) {
          cellStyle = cellStyle.copyWith({ verticalAlign: cell.valign || cell.styles.verticalAlign });
        }
        if (cell.styles?.rotateAngle != null) {
          cellStyle = cellStyle.copyWith({ rotateAngle: cell.styles.rotateAngle });
        }
        if (cell.styles?.whiteSpace) {
          cellStyle = cellStyle.copyWith({ whiteSpace: cell.styles.whiteSpace });
        }
        // text-transform from row or cell
        if (row.node?.styles?.textTransform) {
          cellStyle = cellStyle.copyWith({ textTransform: row.node.styles.textTransform });
        }
        if (cell.styles?.textTransform) {
          cellStyle = cellStyle.copyWith({ textTransform: cell.styles.textTransform });
        }
        if (cell.styles) {
          const collapsed = tableNode.styles?.borderCollapse === 'collapse';
          let border;
          if (collapsed) {
            const aboveSlot = rowIdx > 0 ? (matrix.slots[rowIdx - 1]?.[colIdx] ?? null) : null;
            const abovePlacement = aboveSlot != null ? matrix.placements[aboveSlot.placementIdx] : null;
            const aboveHasBottom = (abovePlacement?.style?.cellBorder ?? '').includes('bottom:');

            const leftSlot = colIdx > 0 ? (matrix.slots[rowIdx]?.[colIdx - 1] ?? null) : null;
            const leftPlacement = leftSlot != null ? matrix.placements[leftSlot.placementIdx] : null;
            const leftHasRight = (leftPlacement?.style?.cellBorder ?? '').includes('right:');

            // Draw top when above has no bottom; draw left when left has no right.
            // Both are handled on the current cell ("first-fix" approach) so colspan/rowspan
            // cells get a border that spans their full width/height.
            // A post-processing pass (_convertLeftToRight) will shift left→right on neighbors
            // for pixel-accurate vertical alignment once all rows are in the matrix.
            const drawTop  = rowIdx === 0 || !abovePlacement || !aboveHasBottom;
            const drawLeft = colIdx === 0 || !leftPlacement  || !leftHasRight;

            border = StyleParser.cellBorderCollapsed(cell.styles, drawTop, drawLeft);
          } else {
            border = StyleParser.cellBorderToFlutter(cell.styles);
          }
          if (border) cellStyle = cellStyle.copyWith({ cellBorder: border, rawBorderCss: cell.styles || null });
        }

        const hd = cellHeightMap.get(cell) || { effFontSize: rowFontSize, structuralLines: 1 };
        const placementIdx = matrix.addPlacement({ cell, row: rowIdx, col: colIdx, colspan, rowspan, style: cellStyle, rowNode: row.node, structuralLines: hd.structuralLines, effFontSize: hd.effFontSize });
        matrix.occupy(rowIdx, colIdx, rowspan, colspan, placementIdx);
        colIdx += colspan;
      }
    }

    // Post-processing: convert top→bottom and left→right for pixel-accurate border alignment.
    // Must run after all cells (including rowspan/colspan cells) are placed in the matrix.
    if (tableNode.styles?.borderCollapse === 'collapse') {
      this._convertTopToBottom(matrix);
      this._convertLeftToRight(matrix);
    }

    // Column widths from <colgroup>/<col>
    const colgroups = this.collectColgroups(tableNode);
    const colgroupCols = this.countColgroupColumns(colgroups);
    // Clamp to colgroup count when defined (findFreeColumn may have expanded numCols beyond it)
    matrix.numCols = colgroupCols > 0 ? colgroupCols : Math.max(matrix.numCols, colgroupCols);
    const columnWidths = this.parseColumnWidths(colgroups, matrix.numCols);
    this.fillColumnWidthsFromCells(matrix, columnWidths);
    // Only shrink text-only columns when table doesn't have a percent width.
    // Percent-width tables (e.g. width:100%) should let remaining columns flex to fill space.
    const twStr = tableNode.styles?.width || tableNode.width;
    const isPercentWidth = twStr && StyleParser.parseDimension(twStr)?.unit === '%';
    if (!isPercentWidth) {
      this.estimateShrinkColumnWidths(matrix, columnWidths, this.getPadding(tableNode));
    }
    // Resolve table's own fixed width for refine pass (explicit px on table overrides container estimate)
    let tableEstW = estimatedAvailableWidth;
    const tableWidthStr = tableNode.styles?.width || tableNode.width;
    if (tableWidthStr) {
      const d = this.convertDimension(StyleParser.parseDimension(tableWidthStr));
      if (d && d.unit !== '%') tableEstW = d.value;
    }
    this.refineRowHeights(tableNode, matrix, columnWidths, minRowHeights, tableEstW);
    return { matrix, rowData, columnWidths, minRowHeights };
  },

  collectRows(tableNode) {
    const theadRows = [], tbodyRows = [], tfootRows = [];
    for (const child of tableNode.children) {
      if (child.type === 'thead') {
        for (const tr of child.children) if (tr.type === 'tr') theadRows.push({ node: tr, cells: this.getCells(tr), sectionType: 'thead' });
      } else if (child.type === 'tbody') {
        for (const tr of child.children) if (tr.type === 'tr') tbodyRows.push({ node: tr, cells: this.getCells(tr), sectionType: 'tbody' });
      } else if (child.type === 'tfoot') {
        for (const tr of child.children) if (tr.type === 'tr') tfootRows.push({ node: tr, cells: this.getCells(tr), sectionType: 'tfoot' });
      } else if (child.type === 'tr') {
        tbodyRows.push({ node: child, cells: this.getCells(child), sectionType: 'tbody' });
      }
    }
    return [...theadRows, ...tbodyRows, ...tfootRows];
  },

  getCells(rowNode) {
    return rowNode.children.filter(c => c.type === 'td' || c.type === 'th');
  },

  collectColgroups(tableNode) {
    const colgroups = [];
    for (const child of tableNode.children) {
      if (child.type === 'colgroup') colgroups.push(child);
      else if (child.type === 'col') colgroups.push({ type: 'colgroup', children: [child] });
    }
    return colgroups;
  },

  countColgroupColumns(colgroups) {
    let count = 0;
    for (const cg of colgroups) {
      const cols = (cg.children || []).filter(c => c.type === 'col');
      if (cols.length === 0) count += cg.span || 1;
      else for (const col of cols) count += col.span || 1;
    }
    return count;
  },

  parseColumnWidths(colgroups, numCols) {
    const widths = new Array(numCols).fill(null);
    let idx = 0;
    for (const cg of colgroups) {
      const cgWidth = cg.width;
      const cols = (cg.children || []).filter(c => c.type === 'col');
      if (cols.length === 0) {
        const span = cg.span || 1;
        for (let i = 0; i < span && idx < numCols; i++) widths[idx++] = this.parseWidth(cgWidth);
      } else {
        for (const col of cols) {
          const span = col.span || 1;
          // Luckysheet uses style="width: 73px;" on <col> — check styles too
          let w = col.width || cgWidth;
          if (!w && col.styles?.width) w = col.styles.width;
          for (let i = 0; i < span && idx < numCols; i++) widths[idx++] = this.parseWidth(w);
        }
      }
    }
    return widths;
  },

  parseWidth(w) {
    if (!w) return null;
    const dim = this.convertDimension(StyleParser.parseDimension(w));
    if (!dim) return null;
    return { type: dim.unit === '%' ? 'percent' : 'fixed', value: dim.value };
  },

  // Convert CSS line-height to Flutter TextStyle.height ratio (line-height / font-size).
  resolveLineHeightRatio(value, fontSize) {
    if (!value || value === 'normal') return null;
    const str = String(value).trim();
    if (/^[\d.]+$/.test(str)) return parseFloat(str);          // unitless ratio: 1.5
    if (str.endsWith('%')) return parseFloat(str) / 100;        // 150% → 1.5
    const dim = StyleParser.parseDimension(str);
    if (dim && dim.unit !== '%') return dim.value / (fontSize || 12);  // 18px / 12px = 1.5
    return null;
  },

  // Scan all single-column cell placements for explicit width attributes/styles.
  // Fills in columnWidths[i] only where colgroup didn't already provide a width.
  // Takes the maximum explicit width found across all rows for each column.
  fillColumnWidthsFromCells(matrix, columnWidths) {
    for (const p of matrix.placements) {
      if (p.colspan !== 1) continue;           // skip multi-span cells
      const col = p.col;
      if (col >= columnWidths.length) continue;
      if (columnWidths[col] !== null) continue; // colgroup already set this column

      const cell = p.cell;
      const w = cell.width || cell.styles?.width || null;
      if (!w) continue;

      const parsed = this.parseWidth(w);
      if (!parsed) continue;

      // Keep the largest explicit width found across rows for this column
      const existing = columnWidths[col];
      if (!existing || parsed.value > existing.value) {
        columnWidths[col] = parsed;
      }
    }
  },

  // Second-pass height refinement: only for cells in fixed-width columns.
  // Uses actual colWidth (post-fillColumnWidthsFromCells) so no over-estimation on flex columns.
  refineRowHeights(tableNode, matrix, columnWidths, minRowHeights, estimatedAvailableWidth = null) {
    const cellPadDefault = this.getPadding(tableNode);
    const numCols = matrix.numCols;

    // Pre-compute estimated pixel width for each column using estimatedAvailableWidth
    // This lets us wrap-estimate even for percent/flex columns when we know the container width.
    let estColWidths = null;
    if (estimatedAvailableWidth != null) {
      let totalFixed = 0, totalPercent = 0, flexCount = 0;
      for (let i = 0; i < numCols; i++) {
        const w = columnWidths[i];
        if (w?.type === 'fixed') totalFixed += w.value;
        else if (w?.type === 'percent') totalPercent += w.value;
        else flexCount++;
      }
      const percentSpace = estimatedAvailableWidth * (totalPercent / 100);
      const flexSpace = Math.max(0, estimatedAvailableWidth - totalFixed - percentSpace);
      const flexUnit = flexCount > 0 ? flexSpace / flexCount : 0;
      estColWidths = columnWidths.map(w => {
        if (w?.type === 'fixed')   return w.value;
        if (w?.type === 'percent') return estimatedAvailableWidth * (w.value / 100);
        return flexUnit;
      });
    }

    for (const p of matrix.placements) {
      const col = p.col;
      if (col >= columnWidths.length) continue;

      // Skip cells with white-space:nowrap — text won't wrap, so row height
      // should stay at the HTML-declared value, not inflate from wrap estimation.
      const ws = p.cell.styles?.whiteSpace || p.style?.whiteSpace;
      if (ws === 'nowrap') continue;


      // Sum widths across the entire colspan span
      let colW = 0;
      for (let c = col; c < col + p.colspan && c < numCols; c++) {
        const w = columnWidths[c];
        if (w?.type === 'fixed' || w?.type === 'shrink') {
          colW += w.value;
        } else if (estColWidths) {
          colW += estColWidths[c];
        } else {
          colW = 0;
          break;
        }
      }
      if (colW <= 0) continue;

      const effFontSize = p.effFontSize || 16;
      const structuralLines = p.structuralLines || 1;
      const text = this.extractText(p.cell);
      if (!text) continue;

      const cs = p.cell.styles || {};
      const pt = cs.paddingTop    ? (this.convertDimension(StyleParser.parseDimension(cs.paddingTop))?.value    ?? cellPadDefault) : cellPadDefault;
      const pb = cs.paddingBottom ? (this.convertDimension(StyleParser.parseDimension(cs.paddingBottom))?.value ?? cellPadDefault) : cellPadDefault;
      const pl = cs.paddingLeft   ? (this.convertDimension(StyleParser.parseDimension(cs.paddingLeft))?.value   ?? cellPadDefault) : cellPadDefault;
      const pr = cs.paddingRight  ? (this.convertDimension(StyleParser.parseDimension(cs.paddingRight))?.value  ?? cellPadDefault) : cellPadDefault;
      const bt = cs.borderTopWidth    ? (StyleParser.parseDimension(cs.borderTopWidth)?.value    ?? 0) : 0;
      const bb = cs.borderBottomWidth ? (StyleParser.parseDimension(cs.borderBottomWidth)?.value ?? 0) : 0;

      const textWidth = colW - pl - pr;
      if (textWidth <= 0) continue;

      const lineHeight = effFontSize * 1.5;
      let wrapLines;

      const fontFamily = p.style?.fontFamily || 'Arial';
      const font = `${effFontSize}px ${fontFamily}`;
      const prepared = Pretext.prepare(text, font);
      const result = Pretext.layout(prepared, textWidth, lineHeight);
      wrapLines = result.lineCount;

      if (wrapLines <= structuralLines) continue;

      const cellH = Math.ceil(lineHeight * wrapLines) + pt + pb + bt + bb;
      if (cellH > minRowHeights[p.row]) {
        minRowHeights[p.row] = cellH;
      }
    }

  },

  render(node, table, context, parentStyle) {
    const { matrix, columnWidths, minRowHeights } = table;
    const { placements, numRows, numCols } = matrix;
    if (numRows === 0 || numCols === 0) return 'const SizedBox.shrink()';

    const lines = [];
    const borderColor = node.styles?.borderColor
      ? StyleParser.colorToFlutter(node.styles.borderColor)
      : 'Colors.black';
    // Painter draws uniform grid only when HTML border="" attribute > 0 and cells have no per-cell borders.
    // CSS border: on the table draws only the outer frame (handled by Container wrapper), not inner grid.
    const cellsHaveBorder = placements.some(p => p.style.cellBorder);
    const htmlBorderAttr = parseInt(node.border) || 0;
    const painterBorderWidth = (!cellsHaveBorder && htmlBorderAttr > 0) ? 1.0 : 0.0;
    const padding = this.getPadding(node);
    const matrixData = matrix.toMatrixData();

    // If table has explicit height, distribute to rows proportionally
    let rowHeights = [...minRowHeights];
    if (node.styles?.height) {
      const tableDim = this.convertDimension(StyleParser.parseDimension(node.styles.height));
      if (tableDim && tableDim.unit !== '%') {
        const tableH = tableDim.value;
        const sumH = rowHeights.reduce((a, b) => a + b, 0);
        if (tableH > sumH) {
          const extra = tableH - sumH;
          const perRow = extra / rowHeights.length;
          rowHeights = rowHeights.map(h => h + perRow);
        }
      }
    }

    // Resolve explicit table width (from width="" attr or style="width:")
    const tableWidthStr = node.styles?.width || node.width;
    const tableWidthDim = tableWidthStr ? this.convertDimension(StyleParser.parseDimension(tableWidthStr)) : null;
    const fixedTableWidth = (tableWidthDim && tableWidthDim.unit !== '%') ? tableWidthDim.value : null;

    lines.push('LayoutBuilder(');
    lines.push('  builder: (context, constraints) {');
    if (fixedTableWidth != null) {
      lines.push(`    final availableWidth = ${fixedTableWidth.toFixed(1)}.clamp(0.0, constraints.maxWidth);`);
    } else {
      lines.push('    final availableWidth = constraints.maxWidth;');
    }
    lines.push('');
    const estW = context.containerWidth || null;
    lines.push(this.genColWidthCode(columnWidths, numCols, estW));
    lines.push('');
    lines.push(`    final rowHeights = <double>[${rowHeights.map(h => h.toFixed(1)).join(', ')}];`);
    lines.push('');
    lines.push('    final cs = <double>[0.0];');
    lines.push('    for (final w in colWidths) { cs.add(cs.last + w); }');
    lines.push('    final rs = <double>[0.0];');
    lines.push('    for (final h in rowHeights) { rs.add(rs.last + h); }');
    lines.push('');
    lines.push('    final totalWidth = cs.last;');
    lines.push('    final totalHeight = rs.last;');
    lines.push('');
    lines.push('    Positioned cell(int c, int r, int ce, int re,');
    lines.push('        {Border? border, Color? bg, EdgeInsets pad = EdgeInsets.zero,');
    lines.push('        Alignment align = Alignment.centerLeft, required Widget child}) =>');
    lines.push('      Positioned(left: cs[c], top: rs[r], width: cs[ce] - cs[c], height: rs[re] - rs[r],');
    lines.push('          child: Container(');
    lines.push('              decoration: (border != null || bg != null) ? BoxDecoration(border: border, color: bg) : null,');
    lines.push('              padding: pad, alignment: align, child: child));');
    lines.push('');
    lines.push('    final matrixData = <List<int>>[');
    for (const row of matrixData) {
      lines.push(`      <int>[${row.join(', ')}],`);
    }
    lines.push('    ];');
    lines.push('');
    lines.push('    return SizedBox(');
    lines.push('      width: totalWidth,');
    lines.push('      height: totalHeight,');
    lines.push('      child: Stack(');
    lines.push('        clipBehavior: Clip.hardEdge,');
    lines.push('        children: [');

    for (const p of placements) {
      lines.push(this.renderCell(p, numCols, numRows, context, padding, parentStyle));
    }

    lines.push('          Positioned.fill(');
    lines.push('            child: IgnorePointer(child: CustomPaint(');
    lines.push('              painter: _TableGridPainter(');
    lines.push('                colStarts: cs,');
    lines.push('                rowStarts: rs,');
    lines.push(`                borderColor: ${borderColor},`);
    lines.push(`                borderWidth: ${painterBorderWidth.toFixed(1)},`);
    lines.push('                matrixData: matrixData,');
    lines.push(`                numRows: ${numRows},`);
    lines.push(`                numCols: ${numCols},`);
    lines.push('              ),');
    lines.push('            )),');
    lines.push('          ),');
    lines.push('        ],');
    lines.push('      ),');
    lines.push('    );');
    lines.push('  },');
    lines.push(')');

    // Wrap in Container if the table itself has outer border, margin, or padding
    const tableBorder = StyleParser.cellBorderToFlutter(node.styles || {});
    const ts = node.styles || {};
    const marginTop    = StyleParser.parseDimension(ts.marginTop)?.value;
    const marginRight  = StyleParser.parseDimension(ts.marginRight)?.value;
    const marginBottom = StyleParser.parseDimension(ts.marginBottom)?.value;
    const marginLeft   = StyleParser.parseDimension(ts.marginLeft)?.value;
    const paddingTop    = StyleParser.parseDimension(ts.paddingTop)?.value;
    const paddingRight  = StyleParser.parseDimension(ts.paddingRight)?.value;
    const paddingBottom = StyleParser.parseDimension(ts.paddingBottom)?.value;
    const paddingLeft   = StyleParser.parseDimension(ts.paddingLeft)?.value;
    const hasMargin  = marginTop  || marginRight  || marginBottom  || marginLeft;
    const hasPadding = paddingTop || paddingRight || paddingBottom || paddingLeft;

    // Tables with all fixed/shrink columns (no flex/percent) or explicit fixed width
    // need UnconstrainedBox to exceed parent constraints and be scrollable
    const allColumnsFixed = columnWidths.length > 0 && columnWidths.every(w => w?.type === 'fixed' || w?.type === 'shrink');
    const needsUnconstrained = fixedTableWidth != null || allColumnsFixed;

    const tableBgColor = ts.backgroundColor ? StyleParser.colorToFlutter(ts.backgroundColor) : null;

    if (tableBorder || hasMargin || hasPadding || tableBgColor) {
      const wrapProps = [];
      if (hasMargin) {
        const mt = marginTop    ?? 0;
        const mr = marginRight  ?? 0;
        const mb = marginBottom ?? 0;
        const ml = marginLeft   ?? 0;
        wrapProps.push(`margin: EdgeInsets.fromLTRB(${ml}, ${mt}, ${mr}, ${mb})`);
      }
      if (hasPadding) {
        const pt = paddingTop    ?? 0;
        const pr = paddingRight  ?? 0;
        const pb = paddingBottom ?? 0;
        const pl = paddingLeft   ?? 0;
        wrapProps.push(`padding: EdgeInsets.fromLTRB(${pl}, ${pt}, ${pr}, ${pb})`);
      }
      if (tableBorder || tableBgColor) {
        const decorParts = [];
        if (tableBorder) decorParts.push(`border: ${tableBorder}`);
        if (tableBgColor) decorParts.push(`color: ${tableBgColor}`);
        wrapProps.push(`decoration: BoxDecoration(${decorParts.join(', ')})`);
      }
      const inner = lines.join('\n');
      const wrapped = `Container(\n  ${wrapProps.join(',\n  ')},\n  child: ${inner},\n)`;
      return needsUnconstrained
        ? `UnconstrainedBox(\n  alignment: Alignment.topLeft,\n  child: ${wrapped},\n)`
        : wrapped;
    }

    const base = lines.join('\n');
    return needsUnconstrained
      ? `UnconstrainedBox(\n  alignment: Alignment.topLeft,\n  child: ${base},\n)`
      : base;
  },

  // Extract text segments split by <br> tags, returning only non-empty lines.
  extractTextLines(node) {
    const lines = [];
    let current = '';
    const walk = (n) => {
      if (n.type === 'text') {
        current += n.content.replace(/[\r\n\t]+/g, ' ').replace(/ {2,}/g, ' ');
      } else if (n.tagName === 'br') {
        lines.push(current);
        current = '';
      } else {
        for (const child of (n.children || [])) walk(child);
      }
    };
    walk(node);
    lines.push(current);
    return lines.filter(l => l.trim());
  },

  // Returns true if the cell (or any descendant) is an interactive form widget.
  cellHasFormWidget(cell) {
    const formTypes = new Set(['input', 'select', 'textarea', 'date-picker', 'signature', 'image-upload', 'table']);
    if (formTypes.has(cell.type)) return true;
    for (const child of (cell.children || [])) {
      if (this.cellHasFormWidget(child)) return true;
    }
    return false;
  },

  // For columns with no explicit width: if the column contains only text (no form widgets),
  // estimate an intrinsic width from the longest text + padding so it shrinks to fit.
  // Columns that contain inputs/selects/etc. remain null (flex fill).
  estimateShrinkColumnWidths(matrix, columnWidths, padding) {
    for (let c = 0; c < matrix.numCols; c++) {
      if (columnWidths[c] !== null) continue;

      let hasFormWidget = false;
      let maxTextPixels = 0;

      for (const p of matrix.placements) {
        if (p.colspan !== 1 || p.col !== c) continue;
        if (this.cellHasFormWidget(p.cell)) { hasFormWidget = true; break; }
        const lines = this.extractTextLines(p.cell);
        if (lines.length === 0) continue;
        const bold = p.style?.fontWeight === 'FontWeight.bold';
        const fs = p.effFontSize || 16;
        const charW = fs * (bold ? 0.85 : 0.72);
        for (const line of lines) {
          const pixels = this.visualLength(line.trim()) * charW;
          if (pixels > maxTextPixels) maxTextPixels = pixels;
        }
      }

      if (!hasFormWidget && maxTextPixels > 0) {
        const estimated = Math.ceil(maxTextPixels) + padding * 2;
        columnWidths[c] = { type: 'shrink', value: Math.max(estimated, 40) };
      }
    }
  },

  genColWidthCode(columnWidths, numCols, estimatedAvailableWidth = null) {
    const lines = [];
    let totalFixed = 0, totalPercent = 0, flexCount = 0;
    for (let i = 0; i < numCols; i++) {
      const w = columnWidths[i];
      if (w?.type === 'fixed' || w?.type === 'shrink') totalFixed += w.value;
      else if (w?.type === 'percent') totalPercent += w.value;
      else flexCount++;
    }

    // When container width is known, resolve percent columns to fixed pixel values
    // so they don't depend on runtime availableWidth (which may be infinity)
    if (estimatedAvailableWidth != null && totalPercent > 0) {
      const resolvedWidths = [];
      let resolvedFixed = 0;
      for (let i = 0; i < numCols; i++) {
        const w = columnWidths[i];
        if (w?.type === 'fixed' || w?.type === 'shrink') {
          resolvedWidths.push({ type: 'fixed', value: w.value });
          resolvedFixed += w.value;
        } else if (w?.type === 'percent') {
          const px = estimatedAvailableWidth * (w.value / 100);
          resolvedWidths.push({ type: 'fixed', value: Math.round(px * 10) / 10 });
          resolvedFixed += px;
        } else {
          resolvedWidths.push(null);
        }
      }
      const resolvedFlexSpace = Math.max(0, estimatedAvailableWidth - resolvedFixed);
      const resolvedFlexUnit = flexCount > 0 ? resolvedFlexSpace / flexCount : 0;

      lines.push(`    final fixedTotal = ${resolvedFixed.toFixed(1)};`);
      lines.push('    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);');
      lines.push(`    final flexUnit = availableWidth.isInfinite ? ${resolvedFlexUnit > 0 ? resolvedFlexUnit.toFixed(1) : '200.0'} : flexSpace / ${Math.max(flexCount, 0.001).toFixed(6)};`);
      lines.push('    final colWidths = <double>[');
      for (let i = 0; i < numCols; i++) {
        const rw = resolvedWidths[i];
        if (rw) lines.push(`      ${rw.value.toFixed(1)},`);
        else lines.push('      flexUnit,');
      }
      lines.push('    ];');
      return lines.join('\n');
    }

    // Original path: no known container width, keep runtime percent calculation
    lines.push(`    final fixedTotal = ${totalFixed.toFixed(1)};`);
    if (totalPercent > 0) {
      lines.push(`    final pctUnit = availableWidth.isInfinite ? 0.0 : availableWidth / 100;`);
      lines.push(`    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal - pctUnit * ${totalPercent.toFixed(1)}).clamp(0.0, double.infinity);`);
    } else {
      lines.push('    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);');
    }
    lines.push(`    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / ${Math.max(flexCount, 0.001).toFixed(6)};`);
    lines.push('    final colWidths = <double>[');
    for (let i = 0; i < numCols; i++) {
      const w = columnWidths[i];
      if (w?.type === 'fixed' || w?.type === 'shrink') lines.push(`      ${w.value.toFixed(1)},`);
      else if (w?.type === 'percent') lines.push(`      pctUnit * ${w.value.toFixed(1)},`);
      else lines.push('      flexUnit,');
    }
    lines.push('    ];');
    return lines.join('\n');
  },

  renderCell(p, numCols, numRows, context, padding, parentStyle) {
    const { cell, row, col, colspan, rowspan, style } = p;
    const colEnd = Math.min(col + colspan, numCols);
    const rowEnd = Math.min(row + rowspan, numRows);
    if (colEnd <= col || rowEnd <= row) return '          // Cell outside bounds';

    const content   = this.cellContent(cell, context, style, parentStyle);
    const alignment = this.alignment(style.textAlign, style.verticalAlign);

    const cellPadding = this.getCellPadding(cell.styles, padding);

    // Check for complex decorations that need fallback to verbose Positioned
    const svgNode = (cell.children || []).find(c => c.type === 'svg');
    const diagLines = svgNode?.diagonalLines || [];
    const hasRotation  = style.rotateAngle != null && style.rotateAngle !== 0;
    const hasDiagonal  = diagLines.length > 0;
    const hasGradient  = !!style.bgGradient;
    const borderHelper = this.borderToHelper(style.cellBorder);
    const complexBorder = style.cellBorder && !borderHelper;

    if (hasRotation || hasDiagonal || hasGradient || complexBorder) {
      // ── Verbose fallback ──────────────────────────────────────────────
      let containerChild;
      if (style.cellBorder || style.bgGradient) {
        const decorProps = [];
        if (style.bgGradient) {
          const g = style.bgGradient;
          const gradColor = StyleParser.colorToFlutter(g.color);
          const stop = (g.percent / 100).toFixed(4);
          const beginAlign = g.direction === 'left'   ? 'Alignment.centerRight'
                           : g.direction === 'top'    ? 'Alignment.bottomCenter'
                           : g.direction === 'bottom' ? 'Alignment.topCenter'
                           :                            'Alignment.centerLeft';
          const endAlign   = g.direction === 'left'   ? 'Alignment.centerLeft'
                           : g.direction === 'top'    ? 'Alignment.topCenter'
                           : g.direction === 'bottom' ? 'Alignment.bottomCenter'
                           :                            'Alignment.centerRight';
          decorProps.push(`gradient: LinearGradient(begin: ${beginAlign}, end: ${endAlign}, colors: [${gradColor}, Colors.transparent], stops: [${stop}, ${stop}])`);
        } else {
          decorProps.push(`color: ${style.bgColor || 'Colors.transparent'}`);
        }
        if (style.cellBorder) decorProps.push(`border: ${style.cellBorder}`);
        containerChild = `Container(
              decoration: BoxDecoration(${decorProps.join(', ')}),
              padding: ${cellPadding}, alignment: ${alignment}, child: ${content})`;
      } else {
        containerChild = `Container(color: ${style.bgColor || 'Colors.transparent'},
              padding: ${cellPadding}, alignment: ${alignment}, child: ${content})`;
      }

      let child = containerChild;
      if (hasRotation) {
        const radians = (style.rotateAngle * Math.PI / 180).toFixed(4);
        child = `Transform.rotate(angle: ${radians}, child: ${containerChild})`;
      }
      if (hasDiagonal) {
        const tlbr = diagLines.some(l => String(l.x1) === '0' && String(l.y1) === '0');
        const bltr = diagLines.some(l => String(l.y1) === '100%');
        const diagColor = StyleParser.colorToFlutter(diagLines[0]?.stroke || '#000000');
        const diagWidth = (diagLines[0]?.strokeWidth || 1).toFixed(1);
        context.usesDiagonalBorder = true;
        child = `Stack(children: [${child}, Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DiagonalBorderPainter(color: ${diagColor}, strokeWidth: ${diagWidth}, topLeftToBottomRight: ${tlbr}, bottomLeftToTopRight: ${bltr}))))])`;
      }
      return `          Positioned(left: cs[${col}], top: rs[${row}], width: cs[${colEnd}] - cs[${col}], height: rs[${rowEnd}] - rs[${row}], child: ${child}),`;
    }

    // ── Skip invisible empty cells (no content, no border, no bg) ────────
    const bg = style.bgColor;
    const hasBg = bg && bg !== 'Colors.transparent';
    const hasBorder = !!borderHelper || !!style.cellBorder;
    const isEmpty = content === 'const SizedBox.shrink()';
    if (isEmpty && !hasBorder && !hasBg) {
      return ''; // skip — invisible cell, no widget needed
    }

    // ── Compact cell() helper ─────────────────────────────────────────────
    const args = [`${col}, ${row}, ${colEnd}, ${rowEnd}`];
    if (borderHelper)  args.push(`border: ${borderHelper}`);
    if (hasBg) args.push(`bg: ${bg}`);
    if (cellPadding !== 'EdgeInsets.all(0.0)' && cellPadding !== 'EdgeInsets.zero') args.push(`pad: ${cellPadding}`);
    if (alignment !== 'Alignment.centerLeft') args.push(`align: ${alignment}`);
    args.push(`child: ${content}`);
    return `          cell(${args.join(', ')}),`;
  },

  // Try to convert a Border(...) string to a _b*() helper call. Returns null if not possible.
  borderToHelper(borderStr) {
    if (!borderStr) return null;
    const blk = 'Colors.black';
    const top  = borderStr.match(new RegExp(`^Border\\(top: BorderSide\\(color: ${blk}, width: ([\\d.]+)\\)\\)$`));
    if (top)  return top[1]  === '1' ? '_bTop()'    : `_bTop(${top[1]})`;
    const bot  = borderStr.match(new RegExp(`^Border\\(bottom: BorderSide\\(color: ${blk}, width: ([\\d.]+)\\)\\)$`));
    if (bot)  return bot[1]  === '1' ? '_bBottom()' : `_bBottom(${bot[1]})`;
    const lft  = borderStr.match(new RegExp(`^Border\\(left: BorderSide\\(color: ${blk}, width: ([\\d.]+)\\)\\)$`));
    if (lft)  return lft[1]  === '1' ? '_bLeft()'   : `_bLeft(${lft[1]})`;
    const rgt  = borderStr.match(new RegExp(`^Border\\(right: BorderSide\\(color: ${blk}, width: ([\\d.]+)\\)\\)$`));
    if (rgt)  return rgt[1]  === '1' ? '_bRight()'  : `_bRight(${rgt[1]})`;
    const tb = borderStr.match(new RegExp(`^Border\\(top: BorderSide\\(color: ${blk}, width: ([\\d.]+)\\), bottom: BorderSide\\(color: ${blk}, width: ([\\d.]+)\\)\\)$`));
    if (tb) return `_bTopBottom(${tb[1]}, ${tb[2]})`;
    const all = borderStr.match(new RegExp(`^Border\\.all\\(color: ${blk}, width: ([\\d.]+)\\)$`));
    if (all) return all[1] === '1' ? '_bAll()' : `_bAll(${all[1]})`;
    return null;
  },

  alignment(h, v) {
    const hMap = { 'start': 'left', 'end': 'right' };
    const hVal = hMap[(h || '').toLowerCase()] || (h || 'left').toLowerCase();
    const vVal = (v || 'middle').toLowerCase();
    if (vVal === 'top'    && hVal === 'left')   return 'Alignment.topLeft';
    if (vVal === 'top'    && hVal === 'center') return 'Alignment.topCenter';
    if (vVal === 'top'    && hVal === 'right')  return 'Alignment.topRight';
    if ((vVal === 'middle' || vVal === 'center') && hVal === 'left')   return 'Alignment.centerLeft';
    if ((vVal === 'middle' || vVal === 'center') && hVal === 'center') return 'Alignment.center';
    if ((vVal === 'middle' || vVal === 'center') && hVal === 'right')  return 'Alignment.centerRight';
    if (vVal === 'bottom' && hVal === 'left')   return 'Alignment.bottomLeft';
    if (vVal === 'bottom' && hVal === 'center') return 'Alignment.bottomCenter';
    if (vVal === 'bottom' && hVal === 'right')  return 'Alignment.bottomRight';
    return 'Alignment.centerLeft';
  },

  getPadding(tableNode) {
    if (tableNode.cellPadding) {
      const dim = this.convertDimension(StyleParser.parseDimension(tableNode.cellPadding));
      if (dim) return dim.value;
    }
    // Luckysheet default: padding: 2px 4px
    if (tableNode.styles?.paddingTop) {
      const dim = this.convertDimension(StyleParser.parseDimension(tableNode.styles.paddingTop));
      if (dim) return dim.value;
    }
    return 4;
  },

  getCellPadding(cellStyles, tableDefault) {
    if (!cellStyles) return `EdgeInsets.all(${tableDefault.toFixed(1)})`;
    const top    = cellStyles.paddingTop    ? this.convertDimension(StyleParser.parseDimension(cellStyles.paddingTop))    : null;
    const right  = cellStyles.paddingRight  ? this.convertDimension(StyleParser.parseDimension(cellStyles.paddingRight))  : null;
    const bottom = cellStyles.paddingBottom ? this.convertDimension(StyleParser.parseDimension(cellStyles.paddingBottom)) : null;
    const left   = cellStyles.paddingLeft   ? this.convertDimension(StyleParser.parseDimension(cellStyles.paddingLeft))   : null;
    if (!top && !right && !bottom && !left) return `EdgeInsets.all(${tableDefault.toFixed(1)})`;
    const t = top    ? top.value    : tableDefault;
    const r = right  ? right.value  : tableDefault;
    const b = bottom ? bottom.value : tableDefault;
    const l = left   ? left.value   : tableDefault;
    // Use symmetric shorthand when possible
    if (t === b && r === l) {
      if (t === r) return `EdgeInsets.all(${t.toFixed(1)})`;
      return `EdgeInsets.symmetric(vertical: ${t.toFixed(1)}, horizontal: ${r.toFixed(1)})`;
    }
    return `EdgeInsets.fromLTRB(${l.toFixed(1)}, ${t.toFixed(1)}, ${r.toFixed(1)}, ${b.toFixed(1)})`;
  },

  // ─── Cell Content ────────────────────────────────────────────────────────────

  cellContent(cell, context, style, _parentStyle) {
    // Extract comment tooltip from position:absolute span
    let commentTooltip = null;
    for (const child of (cell.children || [])) {
      if (child.styles?.position === 'absolute' && child.attributes?.title) {
        commentTooltip = child.attributes.title;
        context.usesComment = true;
        break;
      }
    }

    const widget = this._buildCellWidget(cell, context, style);

    if (!commentTooltip) return widget;
    // Wrap with Tooltip + red corner indicator
    return `Tooltip(
                message: '${this.escapeString(commentTooltip)}',
                child: Stack(
                  children: [
                    ${widget},
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CustomPaint(
                        size: const Size(8, 8),
                        painter: _CommentIndicatorPainter(),
                      ),
                    ),
                  ],
                ),
              )`;
  },

  // Build the cell content widget (pure content, no comment wrapping)
  _buildCellWidget(cell, context, style) {
    // Filter SVG overlays and position:absolute comment triangles
    const contentChildren = (cell.children || []).filter(child => {
      if (child.type === 'svg') return false;                    // SVGNode diagonal border
      if (child.tagName === 'svg') return false;                 // ElementNode fallback
      if (child.styles?.position === 'absolute') return false;  // comment triangle
      return true;
    });

    // Special interactive widgets (nested table, form controls)
    const formTypes = new Set(['input','select','textarea','date-picker','signature','image-upload','checkbox','radio','file','search']);
    const hasSpecial = contentChildren.some(c => c.type === 'table' || formTypes.has(c.type));
    if (hasSpecial) {
      const _renderNestedTable = (child) => {
        // Calculate cell's pixel width to pass as containerWidth for nested table
        let nestedContainerW = null;
        if (context.containerWidth != null) {
          const cellWidthStr = cell.width || cell.styles?.width;
          if (cellWidthStr) {
            const d = this.convertDimension(StyleParser.parseDimension(cellWidthStr));
            if (d && d.unit === '%') nestedContainerW = context.containerWidth * (d.value / 100);
            else if (d) nestedContainerW = d.value;
          } else {
            nestedContainerW = context.containerWidth;
          }
        }
        const isolated = {
          controllers: context.controllers,
          dropdowns:   context.dropdowns,
          checkboxes:  context.checkboxes,
          customWidgets: context.customWidgets,
          containerWidth: nestedContainerW,
          usesTable: true, usesDiagonalBorder: false, usesComment: false, usesGesture: false, usesFormWidgets: false,
        };
        const result = this.generate(child, isolated, style);
        if (isolated.usesDiagonalBorder) context.usesDiagonalBorder = true;
        if (isolated.usesComment)        context.usesComment        = true;
        if (isolated.usesGesture)        context.usesGesture        = true;
        if (isolated.usesFormWidgets)    context.usesFormWidgets    = true;
        return result;
      };

      const segments = [];
      for (const child of contentChildren) {
        if (child.type === 'table')         { segments.push(_renderNestedTable(child)); continue; }
        if (child.type === 'input')         { segments.push(this.inputWidget(child, context)); continue; }
        if (child.type === 'select')        { segments.push(this.selectWidget(child, context)); continue; }
        if (child.type === 'textarea')      { segments.push(this.textareaWidget(child, context)); continue; }
        if (child.type === 'date-picker')   { segments.push(this.datepickerWidget(child, context)); continue; }
        if (child.type === 'signature')     { segments.push(this.signatureWidget(child, context)); continue; }
        if (child.type === 'image-upload')  { segments.push(this.imageUploadWidget(child, context)); continue; }
        if (child.type === 'checkbox')      { segments.push(this.checkboxWidget(child, context)); continue; }
        if (child.type === 'radio')         { segments.push(this.radioWidget(child, context)); continue; }
        if (child.type === 'file')          { segments.push(this.fileWidget(child, context)); continue; }
        if (child.type === 'search')        { segments.push(this.searchWidget(child, context)); continue; }
        // Non-special sibling content (text, p, div, span, etc.) — render recursively
        const sibling = this._renderMixedChild(child, style, context);
        if (sibling) segments.push(sibling);
      }
      if (segments.length === 0) return 'const SizedBox.shrink()';
      if (segments.length === 1) return segments[0];
      return `Column(\n                crossAxisAlignment: CrossAxisAlignment.stretch,\n                children: [\n                  ${segments.join(',\n                  ')},\n                ],\n              )`;
    }

    // Block-level children (div, p, headings) require Column layout with per-segment alignment
    const blockTags = new Set(['div','p','h1','h2','h3','h4','h5','h6','ul','ol']);
    if (contentChildren.some(c => blockTags.has(c.tagName))) {
      return this.buildColumnContent(contentChildren, style, context);
    }

    // Detect Luckysheet icon set pattern: <span style="margin-right:Xpx;">emoji</span> + text
    const firstChild = contentChildren[0];
    if (firstChild?.tagName === 'span' && firstChild.styles?.marginRight && contentChildren.length >= 2) {
      const iconText = this.extractText(firstChild);
      if (iconText) {
        const marginDim  = StyleParser.parseDimension(firstChild.styles.marginRight);
        const spacing    = marginDim ? marginDim.value.toFixed(1) : '4.0';
        const restText   = this.extractText({ children: contentChildren.slice(1) });
        const fontSize   = style.fontSize   ? style.fontSize.toFixed(1)   : '16.0';
        const fontFamily = style.fontFamily || 'Browallia New';
        const textProps  = [`fontFamily: '${fontFamily}'`, `fontSize: ${fontSize}`];
        if (style.fontWeight) textProps.push(`fontWeight: ${style.fontWeight}`);
        if (style.textColor)  textProps.push(`color: ${style.textColor}`);
        return `Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${this.escapeString(iconText)}'),
                  SizedBox(width: ${spacing}),
                  Text('${this.escapeString(restText)}', style: TextStyle(${textProps.join(', ')})),
                ],
              )`;
      }
    }

    // Detect rich text: semantic tags always produce styled spans; styled span/a also; <br> needs RichText for proper newline
    const semanticTags = new Set(['b','strong','i','em','u','s','strike']);
    const hasRichText = contentChildren.some(c =>
      semanticTags.has(c.tagName) ||
      c.tagName === 'br' ||
      ((c.tagName === 'span' || c.tagName === 'a') && c.styles && Object.keys(c.styles).length > 0)
    );
    const hasMixedContent = contentChildren.some(c => c.tagName === 'span' || c.tagName === 'a' || semanticTags.has(c.tagName))
      && contentChildren.some(c => c.type === 'text');

    if (hasRichText || hasMixedContent) {
      const rtSoftWrap    = style.whiteSpace !== 'nowrap';
      const rtHasEllipsis = cell.styles?.textOverflow === 'ellipsis';
      const rtOverflow    = !rtSoftWrap && rtHasEllipsis ? 'TextOverflow.ellipsis'
                          : rtSoftWrap                   ? 'TextOverflow.clip'
                          :                               'TextOverflow.visible';
      return this.buildRichText(contentChildren, style, rtSoftWrap, rtOverflow, context);
    }

    const _preserveNl = ['pre', 'pre-wrap', 'pre-line'].includes(style.whiteSpace);
    let text = _preserveNl
      ? this.extractTextPreserveNewlines({ children: contentChildren })
      : this.extractText({ children: contentChildren });
    if (!text || !text.trim()) return 'const SizedBox.shrink()';

    // Apply text-transform
    if (style.textTransform === 'uppercase') text = text.toUpperCase();
    else if (style.textTransform === 'lowercase') text = text.toLowerCase();

    const fontSize   = style.fontSize   ? style.fontSize.toFixed(1)   : '16.0';
    const fontFamily = style.fontFamily || 'Browallia New';
    const styleProps = [`fontFamily: '${fontFamily}'`, `fontSize: ${fontSize}`];
    if (style.fontWeight)          styleProps.push(`fontWeight: ${style.fontWeight}`);
    if (style.fontStyle)           styleProps.push(`fontStyle: ${style.fontStyle}`);
    if (style.textColor)           styleProps.push(`color: ${style.textColor}`);
    if (style.textDecoration)      styleProps.push(`decoration: ${style.textDecoration}`);
    if (style.textDecorationStyle) styleProps.push(`decorationStyle: ${style.textDecorationStyle}`);
    if (style.lineHeight)          styleProps.push(`height: ${style.lineHeight.toFixed(3)}`);

    // Default wrap; disable only for white-space:nowrap
    const softWrap    = style.whiteSpace !== 'nowrap';
    const hasEllipsis = cell.styles?.textOverflow === 'ellipsis';
    const overflow    = !softWrap && hasEllipsis ? 'TextOverflow.ellipsis'
                      : softWrap                 ? 'TextOverflow.clip'
                      :                            'TextOverflow.visible';

    const ta    = StyleParser.textAlignToFlutter(style.textAlign);
    const taArg = ta && ta !== 'TextAlign.left' ? `, textAlign: ${ta}` : '';

    // Use _t() helper for common case (wrap+clip, no textDecoration, no lineHeight)
    const canUseTHelper = softWrap && !hasEllipsis && !style.textDecoration && !style.lineHeight;
    if (canUseTHelper) {
      const tArgs = [`'${this.escapeString(text)}'`];
      const fs = style.fontSize;
      if (fs && Math.abs(fs - 16) > 0.01) tArgs.push(`sz: ${fs.toFixed(1)}`);
      if (style.fontWeight === 'FontWeight.bold') tArgs.push('bold: true');
      if (style.textColor) tArgs.push(`color: ${style.textColor}`);
      const ff = style.fontFamily;
      if (ff && ff !== 'Browallia New') tArgs.push(`ff: '${ff}'`);
      if (ta && ta !== 'TextAlign.left') tArgs.push(`align: ${ta}`);
      return `_t(${tArgs.join(', ')})`;
    }

    return `DefaultTextStyle.merge(
                style: TextStyle(${styleProps.join(', ')}),
                child: Text('${this.escapeString(text)}', softWrap: ${softWrap}, overflow: ${overflow}${taArg}),
              )`;
  },

  // Check if children can be expressed as simple [(text, isBold)] pairs for _rt()
  _isSimpleRichText(children) {
    for (const child of children) {
      if (child.type === 'text') continue;
      if (child.tagName === 'br') continue;
      if (child.tagName === 'a') return false;
      if (['b', 'strong'].includes(child.tagName)) continue;
      if (['span', 'em', 'i', 'u', 's', 'strike'].includes(child.tagName)) return false;
    }
    return true;
  },

  _buildRtPairs(children, textTransform = null) {
    const pairs = [];
    let buf = '', isBold = false;
    const flush = () => { if (buf) { pairs.push(`('${this.escapeString(buf)}', ${isBold})`); buf = ''; } };
    const add = (node, bold) => {
      if (node.type === 'text') {
        let t = node.content.replace(/[\r\n\t]+/g, ' ').replace(/ {2,}/g, ' ');
        if (textTransform === 'uppercase') t = t.toUpperCase();
        else if (textTransform === 'lowercase') t = t.toLowerCase();
        if (!t.trim()) return;
        if (bold !== isBold) { flush(); isBold = bold; }
        buf += t;
      } else if (node.tagName === 'br') {
        flush();
        pairs.push("('\\n', false)");
        isBold = false;
      } else {
        const b = bold || ['b', 'strong'].includes(node.tagName);
        for (const c of (node.children || [])) add(c, b);
      }
    };
    for (const child of children) add(child, false);
    flush();
    return pairs;
  },

  // Add a border side to an existing Flutter Border(...) string, or create a new one.
  // Keeps all borders on the canonical side (right for vertical, bottom for horizontal).
  addBorderSide(borderStr, side, sideValue) {
    if (!sideValue) return borderStr || null;
    if (!borderStr) return `Border(${side}: ${sideValue})`;
    if (borderStr.includes(`${side}:`)) return borderStr; // already has this side
    // Append before the closing ')' of Border(...)
    return borderStr.slice(0, -1) + `, ${side}: ${sideValue})`;
  },

  // Extract the value string of a named border side from a Flutter Border(...) string.
  // e.g. extractBorderSide('Border(right: BorderSide(width: 1))', 'right') → 'BorderSide(width: 1)'
  extractBorderSide(borderStr, side) {
    if (!borderStr) return null;
    const marker = `${side}: `;
    const mIdx = borderStr.indexOf(marker);
    if (mIdx === -1) return null;
    const valStart = mIdx + marker.length;
    let depth = 0, valEnd = valStart;
    for (let i = valStart; i < borderStr.length; i++) {
      if (borderStr[i] === '(') depth++;
      else if (borderStr[i] === ')') {
        if (depth === 0) break;
        depth--;
        if (depth === 0) { valEnd = i + 1; break; }
      }
      valEnd = i + 1;
    }
    return borderStr.slice(valStart, valEnd) || null;
  },

  // Remove a named border side from a Flutter Border(...) string.
  removeBorderSide(borderStr, side) {
    if (!borderStr || !borderStr.includes(`${side}:`)) return borderStr;
    const marker = `${side}: `;
    const mIdx = borderStr.indexOf(marker);
    if (mIdx === -1) return borderStr;
    const valStart = mIdx + marker.length;
    let depth = 0, valEnd = valStart;
    for (let i = valStart; i < borderStr.length; i++) {
      if (borderStr[i] === '(') depth++;
      else if (borderStr[i] === ')') {
        if (depth === 0) break;
        depth--;
        if (depth === 0) { valEnd = i + 1; break; }
      }
      valEnd = i + 1;
    }
    const removal = `${marker}${borderStr.slice(valStart, valEnd)}`;
    let result = borderStr;
    if (result.includes(', ' + removal)) result = result.replace(', ' + removal, '');
    else if (result.includes(removal + ', ')) result = result.replace(removal + ', ', '');
    else result = result.replace(removal, '');
    const inner = result.slice('Border('.length, -1).trim();
    return inner ? result : null;
  },

  // Post-processing pass: for each cell that drew a 'top' border, move it to 'bottom' on the
  // above neighbor. This ensures all horizontal lines at a given row boundary are drawn at the
  // same pixel y position (bottom-side convention), fixing 1px misalignment bugs.
  _convertTopToBottom(matrix) {
    for (const p of matrix.placements) {
      if (p.row === 0) continue;
      const cellBorder = p.style?.cellBorder;
      if (!cellBorder || !cellBorder.includes('top:')) continue;
      const topSide = this.extractBorderSide(cellBorder, 'top');
      if (!topSide) continue;
      let allCovered = true;
      const seen = new Set();
      for (let c = p.col; c < p.col + p.colspan; c++) {
        const aSlot = matrix.slots[p.row - 1]?.[c] ?? null;
        if (aSlot == null) { allCovered = false; continue; }
        if (seen.has(aSlot.placementIdx)) continue;
        seen.add(aSlot.placementIdx);
        const ap = matrix.placements[aSlot.placementIdx];
        if ((ap.style?.cellBorder ?? '').includes('bottom:')) continue;
        const updated = this.addBorderSide(ap.style?.cellBorder, 'bottom', topSide);
        ap.style = ap.style.copyWith({ cellBorder: updated });
      }
      if (allCovered) {
        const newBorder = this.removeBorderSide(cellBorder, 'top');
        p.style = p.style.copyWith({ cellBorder: newBorder });
      }
    }
  },

  // Post-processing pass: for each cell that drew a 'left' border, move it to 'right' on the
  // left neighbor. This ensures all vertical lines at a given column boundary are drawn at the
  // same pixel x position (right-side convention), fixing 1px misalignment bugs.
  _convertLeftToRight(matrix) {
    for (const p of matrix.placements) {
      if (p.col === 0) continue;
      const cellBorder = p.style?.cellBorder;
      if (!cellBorder || !cellBorder.includes('left:')) continue;
      const leftSide = this.extractBorderSide(cellBorder, 'left');
      if (!leftSide) continue;
      let allCovered = true;
      const seen = new Set();
      for (let r = p.row; r < p.row + p.rowspan; r++) {
        const lSlot = matrix.slots[r]?.[p.col - 1] ?? null;
        if (lSlot == null) { allCovered = false; continue; }
        if (seen.has(lSlot.placementIdx)) continue;
        seen.add(lSlot.placementIdx);
        const lp = matrix.placements[lSlot.placementIdx];
        if ((lp.style?.cellBorder ?? '').includes('right:')) continue;
        const updated = this.addBorderSide(lp.style?.cellBorder, 'right', leftSide);
        lp.style = lp.style.copyWith({ cellBorder: updated });
      }
      if (allCovered) {
        const newBorder = this.removeBorderSide(cellBorder, 'left');
        p.style = p.style.copyWith({ cellBorder: newBorder });
      }
    }
  },

  // Extract text content preserving newlines (for pre/pre-wrap/pre-line white-space).
  extractTextPreserveNewlines(node) {
    let text = '';
    for (const c of (node.children || [])) {
      if (c.type === 'text') {
        text += c.content.replace(/\r\n/g, '\n').replace(/\r/g, '\n');
      } else if (c.tagName === 'br') {
        text += '\n';
      } else {
        text += this.extractTextPreserveNewlines(c);
      }
    }
    return text;
  },

  // Build RichText widget for cells with mixed styled spans
  buildRichText(children, baseStyle, softWrap = true, overflow = 'TextOverflow.clip', context = null) {
    // Fast path: simple bold/normal spans → use _rt() helper
    // Skip fast path when preserving newlines (pre/pre-wrap) since _buildRtPairs collapses them.
    const _usePreserveNl = ['pre', 'pre-wrap', 'pre-line'].includes(baseStyle.whiteSpace);
    if (!_usePreserveNl && softWrap && overflow === 'TextOverflow.clip' && this._isSimpleRichText(children)
        && !baseStyle.textColor && !baseStyle.lineHeight) {
      const pairs = this._buildRtPairs(children, baseStyle.textTransform);
      if (pairs.length > 0) {
        const rtArgs = [`[${pairs.join(', ')}]`];
        const fs = baseStyle.fontSize;
        if (fs && Math.abs(fs - 16) > 0.01) rtArgs.push(`sz: ${fs.toFixed(1)}`);
        const ff = baseStyle.fontFamily;
        if (ff && ff !== 'Browallia New') rtArgs.push(`ff: '${ff}'`);
        const ta = StyleParser.textAlignToFlutter(baseStyle.textAlign);
        if (ta && ta !== 'TextAlign.left') rtArgs.push(`align: ${ta}`);
        return `_rt(${rtArgs.join(', ')})`;
      }
    }

    const spans = [];
    const preserveNewlines = ['pre', 'pre-wrap', 'pre-line'].includes(baseStyle.whiteSpace);
    const tt = baseStyle.textTransform; // text-transform

    // Helper: push text content as one or more TextSpans, splitting on \n when preserveNewlines.
    const pushText = (raw, styleStr = null) => {
      if (tt === 'uppercase') raw = raw.toUpperCase();
      else if (tt === 'lowercase') raw = raw.toLowerCase();
      if (preserveNewlines) {
        const lines = raw.replace(/\r\n/g, '\n').replace(/\r/g, '\n').split('\n');
        for (let i = 0; i < lines.length; i++) {
          const line = lines[i];
          if (line) {
            spans.push(styleStr
              ? `TextSpan(text: '${this.escapeString(line)}', style: ${styleStr})`
              : `TextSpan(text: '${this.escapeString(line)}')`);
          }
          if (i < lines.length - 1) spans.push(`TextSpan(text: '\\n')`);
        }
      } else {
        const t = raw.replace(/[\r\n\t]+/g, ' ').replace(/ {2,}/g, ' ');
        if (t.trim()) {
          spans.push(styleStr
            ? `TextSpan(text: '${this.escapeString(t)}', style: ${styleStr})`
            : `TextSpan(text: '${this.escapeString(t)}')`);
        }
      }
    };

    for (const child of children) {
      if (child.type === 'text') {
        pushText(child.content);
        continue;
      }

      if (child.tagName === 'br') {
        spans.push(`TextSpan(text: '\\n')`);
        continue;
      }

      if (child.tagName === 'a') {
        const text = this.extractText(child);
        if (!text) continue;
        const href = child.attributes?.href || '';
        if (context) context.usesGesture = true;
        spans.push(`TextSpan(text: '${this.escapeString(text)}', style: const TextStyle(color: Color(0xFF0066CC), decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () { /* ${href} */ })`);
        continue;
      }

      const inlineTags = ['span','b','strong','i','em','u','s','strike','del','mark','sub','sup'];
      if (inlineTags.includes(child.tagName)) {
        const rawText = preserveNewlines
          ? this.extractTextPreserveNewlines(child)
          : this.extractText(child);
        if (!rawText) continue;
        const sp = this.spanStyles(child.styles || {}, child.tagName);
        const styleStr = sp.length > 0 ? `TextStyle(${sp.join(', ')})` : null;
        pushText(rawText, styleStr);
        continue;
      }

      const text = this.extractText(child);
      if (text) spans.push(`TextSpan(text: '${this.escapeString(text)}')`);
    }

    if (spans.length === 0) return 'const SizedBox.shrink()';

    const fontSize   = baseStyle.fontSize   ? baseStyle.fontSize.toFixed(1)   : '16.0';
    const fontFamily = baseStyle.fontFamily || 'Browallia New';
    const baseProps  = [`fontFamily: '${fontFamily}'`, `fontSize: ${fontSize}`];
    if (baseStyle.fontWeight)  baseProps.push(`fontWeight: ${baseStyle.fontWeight}`);
    if (baseStyle.textColor)   baseProps.push(`color: ${baseStyle.textColor}`);
    if (baseStyle.lineHeight)  baseProps.push(`height: ${baseStyle.lineHeight.toFixed(3)}`);

    const ta     = StyleParser.textAlignToFlutter(baseStyle.textAlign);
    const taLine = ta && ta !== 'TextAlign.left' ? `\n                textAlign: ${ta},` : '';

    return `RichText(
                softWrap: ${softWrap},
                overflow: ${overflow},${taLine}
                text: TextSpan(
                  style: TextStyle(${baseProps.join(', ')}),
                  children: [
                    ${spans.join(',\n                    ')},
                  ],
                ),
              )`;
  },

  // Render a single non-special child (text, span, p, div, etc.) as a string widget.
  // Used when mixing special widgets (table/form) with surrounding content.
  _renderMixedChild(child, style, context) {
    if (child.type === 'text') {
      const t = child.content?.trim();
      return t ? `Text('${this.escapeString(t)}')` : null;
    }
    // If this block child itself contains a nested table, recurse via buildColumnContent
    const blockTags = new Set(['div','p','h1','h2','h3','h4','h5','h6','ul','ol']);
    if (blockTags.has(child.tagName) || child.tagName === 'span' || child.tagName === 'a') {
      const innerHasTable = (child.children || []).some(c => c.type === 'table');
      if (innerHasTable) {
        return this.buildColumnContent(child.children || [], style, context);
      }
      const t = this.extractText(child);
      return t ? `Text('${this.escapeString(t)}')` : null;
    }
    return null;
  },

  // Render cell content that contains block-level elements (div, p, etc.) as a Column.
  // Inline nodes before/between/after block elements are grouped and rendered as Text or RichText.
  buildColumnContent(children, style, context) {
    const blockTags = new Set(['div','p','h1','h2','h3','h4','h5','h6','ul','ol']);
    const segments = [];
    let inlineGroup = [];

    const flushInline = () => {
      if (inlineGroup.length === 0) return;
      const w = this.buildRichText(inlineGroup, style, true, 'TextOverflow.clip', context);
      if (w && w !== 'const SizedBox.shrink()') segments.push(w);
      inlineGroup = [];
    };

    for (const child of children) {
      if (child.tagName === 'br') {
        flushInline();
      } else if (child.type === 'table') {
        // Nested table directly inside a cell (reached via div/p wrapper path)
        flushInline();
        const isolated = {
          controllers: context.controllers,
          dropdowns:   context.dropdowns,
          checkboxes:  context.checkboxes,
          customWidgets: context.customWidgets,
          usesTable: true, usesDiagonalBorder: false, usesComment: false, usesGesture: false, usesFormWidgets: false,
        };
        const result = this.generate(child, isolated, style);
        if (isolated.usesDiagonalBorder) context.usesDiagonalBorder = true;
        if (isolated.usesComment)        context.usesComment        = true;
        if (isolated.usesGesture)        context.usesGesture        = true;
        if (isolated.usesFormWidgets)    context.usesFormWidgets    = true;
        segments.push(result);
      } else if (blockTags.has(child.tagName)) {
        flushInline();
        // If this block child contains a nested table, recurse into it
        const innerHasTable = (child.children || []).some(c => c.type === 'table');
        if (innerHasTable) {
          const nested = this.buildColumnContent(child.children || [], style, context);
          if (nested && nested !== 'const SizedBox.shrink()') segments.push(nested);
          continue;
        }
        // Check if block child has styled inline content (e.g. <p><span style="font-weight:700">A</span><span>B</span></p>)
        const semanticTags = new Set(['b','strong','i','em','u','s','strike']);
        const hasStyledInline = (child.children || []).some(c =>
          semanticTags.has(c.tagName) ||
          c.tagName === 'br' ||
          ((c.tagName === 'span' || c.tagName === 'a') && c.styles && Object.keys(c.styles).length > 0)
        );
        if (hasStyledInline) {
          // Use buildRichText to preserve per-span styling
          const rt = this.buildRichText(child.children || [], style, true, 'TextOverflow.clip', context);
          if (rt && rt !== 'const SizedBox.shrink()') segments.push(rt);
          continue;
        }
        const blockText = this.extractText(child);
        if (blockText) {
          // Use child's own font-size if specified, otherwise inherit from cell
          let childFs = style.fontSize || 16;
          if (child.styles?.fontSize) {
            const d = this.convertDimension(StyleParser.parseDimension(child.styles.fontSize));
            if (d) childFs = d.value;
          }
          const fs = childFs.toFixed(1);
          // Use child's own font-family if specified
          const ff = child.styles?.fontFamily
            ? child.styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '')
            : (style.fontFamily || 'Browallia New');
          const props = [`fontFamily: '${ff}'`, `fontSize: ${fs}`];
          // heading tags are always bold
          if (['h1','h2','h3','h4','h5','h6'].includes(child.tagName)) {
            props.push('fontWeight: FontWeight.bold');
          } else if (child.styles?.fontWeight) {
            const fw = StyleParser.fontWeightToFlutter(child.styles.fontWeight);
            if (fw) props.push(`fontWeight: ${fw}`);
          } else if (style.fontWeight) {
            props.push(`fontWeight: ${style.fontWeight}`);
          }
          if (child.styles?.color) props.push(`color: ${StyleParser.colorToFlutter(child.styles.color)}`);
          else if (style.textColor)  props.push(`color: ${style.textColor}`);
          if (style.lineHeight) props.push(`height: ${style.lineHeight.toFixed(3)}`);
          const rawAlign = child.styles?.textAlign || style.textAlign;
          const ta = StyleParser.textAlignToFlutter(rawAlign);
          const taStr = ta && ta !== 'TextAlign.left' ? `, textAlign: ${ta}` : '';
          segments.push(`Text('${this.escapeString(blockText)}', style: TextStyle(${props.join(', ')})${taStr})`);
        }
      } else {
        inlineGroup.push(child);
      }
    }
    flushInline();

    if (segments.length === 0) return 'const SizedBox.shrink()';
    if (segments.length === 1) return segments[0];
    return `Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ${segments.join(',\n                  ')},
                ],
              )`;
  },

  spanStyles(styles, tagName = 'span') {
    const props = [];
    if (tagName === 'b' || tagName === 'strong') props.push('fontWeight: FontWeight.bold');
    if (tagName === 'i' || tagName === 'em')     props.push('fontStyle: FontStyle.italic');
    if (tagName === 'u') props.push('decoration: TextDecoration.underline');
    if (tagName === 's' || tagName === 'strike') props.push('decoration: TextDecoration.lineThrough');

    if (styles.fontWeight) {
      const fw = StyleParser.fontWeightToFlutter(styles.fontWeight);
      if (fw) props.push(`fontWeight: ${fw}`);
    }
    if (styles.fontStyle === 'italic') props.push('fontStyle: FontStyle.italic');
    if (styles.color) {
      const c = StyleParser.colorToFlutter(styles.color);
      if (c) props.push(`color: ${c}`);
    }
    if (styles.fontSize) {
      const dim = this.convertDimension(StyleParser.parseDimension(styles.fontSize));
      if (dim) props.push(`fontSize: ${dim.value.toFixed(1)}`);
    }
    if (styles.fontFamily) {
      const ff = styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
      if (ff) props.push(`fontFamily: '${ff}'`);
    }
    if (styles.textDecoration) {
      const td  = StyleParser.textDecorationToFlutter(styles.textDecoration);
      const tds = StyleParser.textDecorationStyleToFlutter(styles.textDecoration);
      if (td)  props.push(`decoration: ${td}`);
      if (tds) props.push(`decorationStyle: ${tds}`);
    }
    if (styles.backgroundColor) {
      const bg = StyleParser.colorToFlutter(styles.backgroundColor);
      if (bg) props.push(`background: Paint()..color = ${bg}`);
    }

    return props;
  },

  // ─── Form Widgets ────────────────────────────────────────────────────────────

  inputWidget(node, context) {
    const name = node.name || `input_${context.controllers.size}`;
    context.controllers.set(name, { type: 'text', name });
    const ctrl = `_${this.toCamelCase(name)}Controller`;
    // Width: use explicit width as maxWidth (never overflow cell), no explicit = fill cell
    let wCode = null;
    const wStr = node.styles?.width || node.width || null;
    if (wStr) {
      const dim = this.convertDimension(StyleParser.parseDimension(wStr));
      if (dim && dim.unit !== '%') wCode = dim.value.toFixed(1);
    }
    const tf = `TextField(controller: ${ctrl}, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)))`;
    return wCode ? `ConstrainedBox(constraints: const BoxConstraints(maxWidth: ${wCode}), child: ${tf})` : tf;
  },

  selectWidget(node, context) {
    const name = node.name || `select_${context.dropdowns.size}`;
    const varName = `_${this.toCamelCase(name)}`;
    const opts = (node.children || []).filter(c => c.type === 'option').map(o => ({
      value: o.value || this.extractText(o),
      label: this.extractText(o) || o.value,
    }));
    context.dropdowns.set(name, { name, options: opts });
    if (opts.length === 0) return "Text('[Select]')";
    const items = opts.map(o =>
      `DropdownMenuItem(value: '${this.escapeString(o.value)}', child: Text('${this.escapeString(o.label)}', style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16)))`
    );
    return `DropdownButton<String>(value: ${varName}, isDense: true, items: [${items.join(', ')}], onChanged: (v) => setState(() => ${varName} = v))`;
  },

  textareaWidget(node, context) {
    const name = node.name || `textarea_${context.controllers.size}`;
    context.controllers.set(name, { type: 'textarea', name });
    const ctrl = `_${this.toCamelCase(name)}Controller`;
    const rows = node.rows || 3;
    return `TextField(controller: ${ctrl}, maxLines: ${rows}, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)))`;
  },

  datepickerWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || `date_${context.controllers.size}`;
    const props = [`name: '${name}'`];
    if (node.value) props.push(`value: '${node.value}'`);
    if (node.placeholder) props.push(`placeholder: '${node.placeholder}'`);
    if (node.min) props.push(`min: '${node.min}'`);
    if (node.max) props.push(`max: '${node.max}'`);
    if (node.required) props.push('required: true');
    if (node.readonly) props.push('readonly: true');
    return `FormDate(${props.join(', ')})`;
  },

  signatureWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || 'signature';
    const props = [`name: '${name}'`];
    if (node.width) props.push(`width: ${parseFloat(node.width) || 200}`);
    if (node.height) props.push(`height: ${parseFloat(node.height) || 100}`);
    return `FormSignature(${props.join(', ')})`;
  },

  imageUploadWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || 'image';
    const props = [`name: '${name}'`];
    if (node.source && node.source !== 'both') props.push(`source: '${node.source}'`);
    if (node.width) props.push(`width: ${parseFloat(node.width) || 150}`);
    if (node.height) props.push(`height: ${parseFloat(node.height) || 150}`);
    if (node.required) props.push('required: true');
    return `FormImageUpload(${props.join(', ')})`;
  },

  checkboxWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || `checkbox_${context.checkboxes.size}`;
    context.checkboxes.set(name, { name });
    const props = [`name: '${name}'`];
    if (node.label) props.push(`label: '${node.label}'`);
    if (node.options && node.options.length) props.push(`options: [${node.options.map(o => `'${o}'`).join(', ')}]`);
    if (node.hasOther) props.push('hasOther: true');
    if (node.disabled) props.push('disabled: true');
    return `FormCheckbox(${props.join(', ')})`;
  },

  radioWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || 'radio';
    const props = [`name: '${name}'`];
    if (node.options && node.options.length) props.push(`options: [${node.options.map(o => `'${o}'`).join(', ')}]`);
    if (node.required) props.push('required: true');
    if (node.disabled) props.push('disabled: true');
    return `FormRadio(${props.join(', ')})`;
  },

  fileWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || 'file';
    const props = [`name: '${name}'`];
    if (node.accept) props.push(`accept: '${node.accept}'`);
    if (node.multiple) props.push('multiple: true');
    if (node.maxSize) props.push(`maxSizeMb: ${node.maxSize}`);
    if (node.required) props.push('required: true');
    return `FormFile(${props.join(', ')})`;
  },

  searchWidget(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || 'search';
    const props = [`name: '${name}'`, `source: '${node.source || ''}'`];
    if (node.display) props.push(`displayFields: '${node.display}'`);
    if (node.fields) props.push(`fields: '${node.fields}'`);
    if (node.placeholder) props.push(`placeholder: '${node.placeholder}'`);
    if (node.required) props.push('required: true');
    return `FormSearch(${props.join(', ')})`;
  },

  // ─── Utility ─────────────────────────────────────────────────────────────────

  extractText(node) {
    let t = '';
    for (const c of (node.children || [])) {
      if (c.type === 'text') {
        // Normalize HTML source whitespace: collapse newlines/tabs/indent to single space
        t += c.content.replace(/[\r\n\t]+/g, ' ').replace(/ {2,}/g, ' ');
      } else if (c.tagName === 'br') {
        t += '\n';
      } else if (c.type === 'svg' || c.tagName === 'svg') {
        continue;
      } else if (c.styles?.position === 'absolute') {
        continue;
      } else if (c.children) {
        t += this.extractText(c);
      }
    }
    return t.trim();
  },

  // Count grapheme clusters (user-perceived characters) using Intl.Segmenter.
  // Handles all scripts correctly: Thai stacking marks, Arabic, Devanagari, emoji, etc.
  // Falls back to removing Thai combining marks on older browsers.
  visualLength(text) {
    if (typeof Intl !== 'undefined' && Intl.Segmenter) {
      return [...new Intl.Segmenter().segment(text)].length;
    }
    return text.replace(/[\u0E31\u0E34-\u0E3A\u0E47-\u0E4E]/g, '').length;
  },

  escapeString(s) {
    if (!s) return '';
    return s
      .replace(/\\/g, '\\\\')
      .replace(/'/g, "\\'")
      .replace(/\n/g, '\\n')
      .replace(/\r/g, '')
      .replace(/\$/g, '\\$');
  },

  toCamelCase(s) {
    return s
      .replace(/[-_\s]+(.)?/g, (_, c) => c ? c.toUpperCase() : '')
      .replace(/^./, c => c.toLowerCase());
  },

  generateJson(node, contentBuilder, inheritedStyles = null, estimatedWidth = null) {
    const context = { containerWidth: estimatedWidth, usesTable: true, usesGesture: false, usesDiagonalBorder: false, usesComment: false };
    const result = this.buildTable(node, inheritedStyles, estimatedWidth);
    const { matrix, columnWidths, minRowHeights } = result;
    const { placements, numRows, numCols } = matrix;

    if (numRows === 0 || numCols === 0) return null;

    const cellsHaveBorder = placements.some(p => p.style.cellBorder);
    const htmlBorderAttr = parseInt(node.border) || 0;
    const painterBorderWidth = (!cellsHaveBorder && htmlBorderAttr > 0) ? 1.0 : 0.0;
    const padding = this.getPadding(node);

    let rowHeights = [...minRowHeights];
    if (node.styles?.height) {
      const tableDim = this.convertDimension(StyleParser.parseDimension(node.styles.height));
      if (tableDim && tableDim.unit !== '%') {
        const tableH = tableDim.value;
        const sumH = rowHeights.reduce((a, b) => a + b, 0);
        if (tableH > sumH) {
          const extra = tableH - sumH;
          const perRow = extra / rowHeights.length;
          rowHeights = rowHeights.map(h => h + perRow);
        }
      }
    }

    const columnSpecs = [];
    for (let i = 0; i < numCols; i++) {
      const w = columnWidths[i];
      if (w?.type === 'fixed' || w?.type === 'shrink') {
        columnSpecs.push({ type: w.type, value: Math.round(w.value * 10) / 10 });
      } else if (w?.type === 'percent') {
        // Resolve percent to fixed pixel when container width is known
        if (estimatedWidth != null) {
          const px = estimatedWidth * (w.value / 100);
          columnSpecs.push({ type: 'fixed', value: Math.round(px * 10) / 10 });
        } else {
          columnSpecs.push({ type: 'percent', value: Math.round(w.value * 10) / 10 });
        }
      } else {
        columnSpecs.push({ type: 'flex' });
      }
    }

    const matrixData = matrix.toMatrixData();

    const jsonPlacements = [];
    for (const p of placements) {
      const { cell, row, col, colspan, rowspan, style } = p;
      const colEnd = Math.min(col + colspan, numCols);
      const rowEnd = Math.min(row + rowspan, numRows);
      if (colEnd <= col || rowEnd <= row) continue;

      const cellPad = this._getCellPaddingValues(cell.styles, padding);

      const bg = style.bgColor;
      const hasBg = bg && bg !== 'Colors.transparent';
      const hasBorder = !!style.cellBorder;
      const hasContent = (cell.children || []).some(c => {
        if (c.type === 'svg') return false;
        if (c.styles?.position === 'absolute') return false;
        if (c.type === 'text' && !(c.content || '').trim()) return false;
        return true;
      });

      if (!hasContent && !hasBorder && !hasBg) continue;

      const cellStyle = {};
      if (style.textAlign && style.textAlign !== 'left') cellStyle.textAlign = style.textAlign;
      if (style.verticalAlign && style.verticalAlign !== 'middle') cellStyle.verticalAlign = style.verticalAlign;
      if (style.rawBgColor) {
        cellStyle.backgroundColor = style.rawBgColor;
      } else if (style.bgColor && style.bgColor !== 'Colors.transparent') {
        cellStyle.backgroundColor = this._flutterColorToHex(style.bgColor);
      }
      if (style.bgGradient) cellStyle.gradient = style.bgGradient;
      if (style.rawTextColor) {
        cellStyle.color = style.rawTextColor;
      } else if (style.textColor) {
        cellStyle.color = this._flutterColorToHex(style.textColor);
      }
      if (style.fontWeight && style.fontWeight !== 'FontWeight.normal') cellStyle.fontWeight = style.fontWeight === 'FontWeight.bold' ? 'bold' : style.fontWeight;
      if (style.fontStyle === 'FontStyle.italic') cellStyle.fontStyle = 'italic';
      if (style.fontSize) cellStyle.fontSize = style.fontSize;
      if (style.fontFamily) cellStyle.fontFamily = style.fontFamily;
      if (style.cellBorder) {
        const collapsed = node.styles?.borderCollapse === 'collapse';
        if (collapsed) {
          // Collapsed: use style.cellBorder which already passed collapse logic (only relevant sides)
          cellStyle.cellBorder = this._parseCellBorderToJson(style.cellBorder);
        } else {
          // Non-collapsed: prefer raw CSS for accuracy
          const rawBorder = style.rawBorderCss ? this._cssBorderToJson(style.rawBorderCss) : null;
          cellStyle.cellBorder = rawBorder || this._parseCellBorderToJson(style.cellBorder);
        }
      }
      if (style.rotateAngle) cellStyle.rotateAngle = style.rotateAngle;
      if (style.textDecoration) cellStyle.textDecoration = style.textDecoration;
      if (style.textDecorationStyle) cellStyle.textDecorationStyle = style.textDecorationStyle;
      if (style.lineHeight) cellStyle.lineHeight = style.lineHeight;
      if (style.whiteSpace) cellStyle.whiteSpace = style.whiteSpace;
      if (style.textTransform) cellStyle.textTransform = style.textTransform;

      const svgNode = (cell.children || []).find(c => c.type === 'svg');
      const diagLines = svgNode?.diagonalLines || [];

      let commentTooltip = null;
      for (const ch of (cell.children || [])) {
        if (ch.styles?.position === 'absolute' && ch.attributes?.title) {
          commentTooltip = ch.attributes.title;
          break;
        }
      }

      const child = contentBuilder ? contentBuilder(cell) : null;

      const placement = { row, col, colEnd, rowEnd };
      if (cell.dataCell) placement.dataCell = cell.dataCell;
      if (diagLines.length > 0) {
        placement.diagonalLines = diagLines.map(l => ({
          topLeftToBottomRight: String(l.x1) === '0' && String(l.y1) === '0',
          bottomLeftToTopRight: String(l.y1) === '100%',
          color: l.stroke || '#000000',
          width: l.strokeWidth || 1,
        }));
      }
      if (commentTooltip) placement.comment = commentTooltip;
      if (Object.keys(cellStyle).length) placement.style = cellStyle;
      if (cellPad) placement.padding = cellPad;
      placement.child = child;

      jsonPlacements.push(placement);
    }

    const ts = node.styles || {};
    const tableStyle = {};
    const tableBorderCss = StyleParser.cellBorderToFlutter(ts);
    if (tableBorderCss) tableStyle.border = this._parseCellBorderToJson(tableBorderCss);
    const tMargin = {};
    for (const side of ['Top', 'Right', 'Bottom', 'Left']) {
      const v = ts[`margin${side}`];
      if (v) { const d = this.convertDimension(StyleParser.parseDimension(v)); if (d) tMargin[side.toLowerCase()] = d.value; }
    }
    if (Object.keys(tMargin).length) tableStyle.margin = { top: tMargin.top || 0, right: tMargin.right || 0, bottom: tMargin.bottom || 0, left: tMargin.left || 0 };
    const tPadding = {};
    for (const side of ['Top', 'Right', 'Bottom', 'Left']) {
      const v = ts[`padding${side}`];
      if (v) { const d = this.convertDimension(StyleParser.parseDimension(v)); if (d) tPadding[side.toLowerCase()] = d.value; }
    }
    if (Object.keys(tPadding).length) tableStyle.padding = { top: tPadding.top || 0, right: tPadding.right || 0, bottom: tPadding.bottom || 0, left: tPadding.left || 0 };
    if (ts.backgroundColor) {
      const bg = StyleParser.colorToFlutter(ts.backgroundColor);
      if (bg) tableStyle.backgroundColor = this._flutterColorToHex(bg);
    }

    const tableWidthStr = node.styles?.width || node.width;
    const tableWidthDim = tableWidthStr ? this.convertDimension(StyleParser.parseDimension(tableWidthStr)) : null;
    const fixedTableWidth = (tableWidthDim && tableWidthDim.unit !== '%') ? tableWidthDim.value : null;

    const output = {
      type: 'table',
      numRows,
      numCols,
      columnSpecs,
      rowHeights: rowHeights.map(h => Math.round(h * 10) / 10),
      borderWidth: painterBorderWidth,
      matrixData,
      placements: jsonPlacements,
    };
    if (fixedTableWidth != null) output.fixedWidth = Math.round(fixedTableWidth * 10) / 10;
    if (Object.keys(tableStyle).length) output.tableStyle = tableStyle;
    return output;
  },

  _getCellPaddingValues(cellStyles, tableDefault) {
    if (!cellStyles) return { top: tableDefault, right: tableDefault, bottom: tableDefault, left: tableDefault };
    const top    = cellStyles.paddingTop    ? (this.convertDimension(StyleParser.parseDimension(cellStyles.paddingTop))?.value    ?? tableDefault) : tableDefault;
    const right  = cellStyles.paddingRight  ? (this.convertDimension(StyleParser.parseDimension(cellStyles.paddingRight))?.value  ?? tableDefault) : tableDefault;
    const bottom = cellStyles.paddingBottom ? (this.convertDimension(StyleParser.parseDimension(cellStyles.paddingBottom))?.value ?? tableDefault) : tableDefault;
    const left   = cellStyles.paddingLeft   ? (this.convertDimension(StyleParser.parseDimension(cellStyles.paddingLeft))?.value   ?? tableDefault) : tableDefault;
    return { top, right, bottom, left };
  },

  _cssBorderToJson(styles) {
    if (!styles) return null;
    const result = {};
    const sides = ['Top', 'Bottom', 'Left', 'Right'];
    for (const side of sides) {
      const key = side.toLowerCase();
      const shorthand = styles[`border${side}`];
      if (shorthand) {
        const m = String(shorthand).match(/([\d.]+)(?:px)?\s+\w+\s+(#[0-9a-fA-F]{3,8}|\w+(?:\([^)]*\))?)/);
        if (m) {
          result[key] = { width: parseFloat(m[1]), color: m[2] };
          continue;
        }
      }
      const w = styles[`border${side}Width`];
      const c = styles[`border${side}Color`];
      if (w || c) {
        const dim = w ? StyleParser.parseDimension(w) : null;
        result[key] = { width: dim?.value || 1, color: c || '#000000' };
      }
    }
    if (styles.borderBlock || styles.borderBlockStart || styles.borderBlockEnd) {
      const parse = (s) => {
        if (!s) return null;
        const m = String(s).match(/([\d.]+)(?:px)?\s+\w+\s+(#[0-9a-fA-F]{3,8}|\w+)/);
        return m ? { width: parseFloat(m[1]), color: m[2] } : null;
      };
      if (styles.borderBlock) {
        const b = parse(styles.borderBlock);
        if (b) { if (!result.top) result.top = b; if (!result.bottom) result.bottom = b; }
      }
      if (styles.borderBlockStart) { const b = parse(styles.borderBlockStart); if (b && !result.top) result.top = b; }
      if (styles.borderBlockEnd) { const b = parse(styles.borderBlockEnd); if (b && !result.bottom) result.bottom = b; }
    }
    return Object.keys(result).length > 0 ? result : null;
  },

  // Parse Flutter Border(...) string into structured JSON
  _parseCellBorderToJson(borderStr) {
    if (!borderStr) return null;
    const result = {};
    const sidePattern = /(top|bottom|left|right): BorderSide\(color: (Colors?\.\w+|Color\(0x[0-9A-Fa-f]+\)),\s*width: ([\d.]+)\)/g;
    let m;
    while ((m = sidePattern.exec(borderStr)) !== null) {
      result[m[1]] = {
        color: this._flutterColorToHex(m[2]),
        width: parseFloat(m[3]),
      };
    }
    const allMatch = borderStr.match(/Border\.all\(color: (Colors?\.\w+|Color\(0x[0-9A-Fa-f]+\)),\s*width: ([\d.]+)\)/);
    if (allMatch) {
      const c = this._flutterColorToHex(allMatch[1]);
      const w = parseFloat(allMatch[2]);
      result.top = result.bottom = result.left = result.right = { color: c, width: w };
    }
    return Object.keys(result).length > 0 ? result : null;
  },

  _flutterColorToHex(str) {
    if (!str) return null;
    const s = String(str);
    const m = s.match(/Color\(0x([0-9A-Fa-f]{8})\)/);
    if (m) return '#' + m[1].substring(2);
    const named = {
      'Colors.white': '#FFFFFF', 'Colors.black': '#000000', 'Colors.transparent': null,
      'Colors.red': '#F44336', 'Colors.blue': '#2196F3', 'Colors.green': '#4CAF50',
      'Colors.grey': '#9E9E9E', 'Colors.yellow': '#FFEB3B', 'Colors.orange': '#FF9800',
    };
    if (named[s] !== undefined) return named[s];
    const shadeMap = {
      'grey':   { 50:'#FAFAFA', 100:'#F5F5F5', 200:'#EEEEEE', 300:'#E0E0E0', 400:'#BDBDBD', 500:'#9E9E9E', 600:'#757575', 700:'#616161', 800:'#424242', 900:'#212121' },
      'red':    { 50:'#FFEBEE', 100:'#FFCDD2', 200:'#EF9A9A', 300:'#E57373', 400:'#EF5350', 500:'#F44336', 600:'#E53935', 700:'#D32F2F', 800:'#C62828', 900:'#B71C1C' },
      'blue':   { 50:'#E3F2FD', 100:'#BBDEFB', 200:'#90CAF9', 300:'#64B5F6', 400:'#42A5F5', 500:'#2196F3', 600:'#1E88E5', 700:'#1976D2', 800:'#1565C0', 900:'#0D47A1' },
      'green':  { 50:'#E8F5E9', 100:'#C8E6C9', 200:'#A5D6A7', 300:'#81C784', 400:'#66BB6A', 500:'#4CAF50', 600:'#43A047', 700:'#388E3C', 800:'#2E7D32', 900:'#1B5E20' },
      'orange': { 50:'#FFF3E0', 100:'#FFE0B2', 200:'#FFCC80', 300:'#FFB74D', 400:'#FFA726', 500:'#FF9800', 600:'#FB8C00', 700:'#F57C00', 800:'#EF6C00', 900:'#E65100' },
      'yellow': { 50:'#FFFDE7', 100:'#FFF9C4', 200:'#FFF59D', 300:'#FFF176', 400:'#FFEE58', 500:'#FFEB3B', 600:'#FDD835', 700:'#FBC02D', 800:'#F9A825', 900:'#F57F17' },
    };
    const shadeMatch = s.match(/Colors\.(\w+)\.shade(\d+)/);
    if (shadeMatch) {
      const colorName = shadeMatch[1];
      const shade = shadeMatch[2];
      if (shadeMap[colorName]?.[shade]) return shadeMap[colorName][shade];
    }
    const bracketMatch = s.match(/Colors\.(\w+)\[(\d+)\]/);
    if (bracketMatch) {
      const colorName = bracketMatch[1];
      const shade = bracketMatch[2];
      if (shadeMap[colorName]?.[shade]) return shadeMap[colorName][shade];
    }
    return s;
  },
};

if (typeof window !== 'undefined') {
  window.TableHandler = TableHandler;
  window.TableMatrix = TableMatrix;
  window.TableStyleContext = TableStyleContext;
}
if (typeof module !== 'undefined') module.exports = TableHandler;
