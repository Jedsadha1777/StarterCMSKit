const StyleParser = {
  parse(styleStr) {
    if (!styleStr || typeof styleStr !== 'string') return {};
    const styles = {};
    const declarations = styleStr.split(';').filter(s => s.trim());
    for (const declaration of declarations) {
      const colonIndex = declaration.indexOf(':');
      if (colonIndex === -1) continue;
      const property = declaration.slice(0, colonIndex).trim().toLowerCase();
      const value = declaration.slice(colonIndex + 1).trim();
      if (!property || !value) continue;
      const expanded = this.expandShorthand(property, value);
      Object.assign(styles, expanded);
    }
    return styles;
  },

  expandShorthand(property, value) {
    const result = {};
    switch (property) {
      case 'padding':        return this.expandBoxModel('padding', value);
      case 'margin':         return this.expandBoxModel('margin', value);
      case 'border':         return this.expandBorder(value);
      case 'border-top':     return this.parseBorderSide('borderTop', value);
      case 'border-right':   return this.parseBorderSide('borderRight', value);
      case 'border-bottom':  return this.parseBorderSide('borderBottom', value);
      case 'border-left':    return this.parseBorderSide('borderLeft', value);
      case 'border-width':   return this.expandBoxModel('borderWidth', value);
      case 'border-radius':  result.borderRadius = value; return result;
      case 'border-color':   result.borderColor = value; return result;
      case 'border-style':   result.borderStyle = value; return result;
      case 'background':     return this.expandBackground(value);
      case 'background-color': result.backgroundColor = value; return result;
      case 'font':           return this.expandFont(value);
      case 'font-size':      result.fontSize = value; return result;
      case 'font-family':    result.fontFamily = value; return result;
      case 'font-weight':    result.fontWeight = value; return result;
      case 'font-style':     result.fontStyle = value; return result;
      case 'color':          result.color = value; return result;
      case 'text-align':     result.textAlign = value; return result;
      case 'text-decoration':result.textDecoration = value; return result;
      case 'text-overflow':  result.textOverflow = value; return result;
      case 'text-underline-position': result.textUnderlinePosition = value; return result;
      case 'vertical-align': result.verticalAlign = value; return result;
      case 'white-space':    result.whiteSpace = value; return result;
      case 'overflow':       result.overflow = value; return result;
      case 'word-wrap':      result.wordWrap = value; return result;
      case 'line-height':    result.lineHeight = value; return result;
      case 'position':       result.position = value; return result;
      case 'display':        result.display = value; return result;
      case 'width':          result.width = value; return result;
      case 'height':         result.height = value; return result;
      case 'max-width':      result.maxWidth = value; return result;
      case 'min-width':      result.minWidth = value; return result;
      case 'box-sizing':       result.boxSizing = value; return result;
      case 'border-collapse':  result.borderCollapse = value; return result;
      case 'text-transform':   result.textTransform = value; return result;
      // CSS logical properties (block = top+bottom, inline = left+right)
      case 'border-block':        return this.parseBorderBlock(value);
      case 'border-block-start':  return this.parseBorderSide('borderTop', value);
      case 'border-block-end':    return this.parseBorderSide('borderBottom', value);
      case 'border-inline':       return { ...this.parseBorderSide('borderLeft', value), ...this.parseBorderSide('borderRight', value) };
      case 'border-inline-start': return this.parseBorderSide('borderLeft', value);
      case 'border-inline-end':   return this.parseBorderSide('borderRight', value);
      case 'padding-block': {
        const sides = this.expandBoxModel('padding', value);
        return { paddingTop: sides.paddingTop, paddingBottom: sides.paddingTop };
      }
      case 'padding-block-start': result.paddingTop    = value; return result;
      case 'padding-block-end':   result.paddingBottom = value; return result;
      case 'padding-inline': {
        const sides = this.expandBoxModel('padding', value);
        return { paddingLeft: sides.paddingTop, paddingRight: sides.paddingTop };
      }
      case 'padding-inline-start': result.paddingLeft  = value; return result;
      case 'padding-inline-end':   result.paddingRight = value; return result;
      case 'transform': {
        result.transform = value;
        const m = value.match(/rotate\(\s*([-\d.]+)deg\s*\)/);
        if (m) result.rotateAngle = parseFloat(m[1]);
        return result;
      }
      case 'transform-origin': result.transformOrigin = value; return result;
      default: {
        const camelCase = property.replace(/-([a-z])/g, (_, c) => c.toUpperCase());
        result[camelCase] = value;
        return result;
      }
    }
  },

  expandBoxModel(prefix, value) {
    const parts = value.split(/\s+/);
    const result = {};
    switch (parts.length) {
      case 1:
        result[`${prefix}Top`] = parts[0];
        result[`${prefix}Right`] = parts[0];
        result[`${prefix}Bottom`] = parts[0];
        result[`${prefix}Left`] = parts[0];
        break;
      case 2:
        result[`${prefix}Top`] = parts[0];
        result[`${prefix}Right`] = parts[1];
        result[`${prefix}Bottom`] = parts[0];
        result[`${prefix}Left`] = parts[1];
        break;
      case 3:
        result[`${prefix}Top`] = parts[0];
        result[`${prefix}Right`] = parts[1];
        result[`${prefix}Bottom`] = parts[2];
        result[`${prefix}Left`] = parts[1];
        break;
      case 4:
        result[`${prefix}Top`] = parts[0];
        result[`${prefix}Right`] = parts[1];
        result[`${prefix}Bottom`] = parts[2];
        result[`${prefix}Left`] = parts[3];
        break;
    }
    return result;
  },

  expandBorder(value) {
    const result = {};
    const parts = value.split(/\s+/);
    let width = null, style = null, color = null;
    for (const part of parts) {
      if (/^[\d.]/.test(part)) width = part;
      else if (['solid','dashed','dotted','double','none','hidden'].includes(part.toLowerCase())) style = part;
      else color = part;
    }
    // Store as shorthand AND expand to all 4 sides so cellBorderToFlutter can find them
    if (width) result.borderWidth = width;
    if (style) result.borderStyle = style;
    if (color) result.borderColor = color;
    for (const side of ['Top','Right','Bottom','Left']) {
      if (width) result[`border${side}Width`] = width;
      if (style) result[`border${side}Style`] = style;
      if (color) result[`border${side}Color`] = color;
    }
    return result;
  },

  parseBorderBlock(value) {
    return { ...this.parseBorderSide('borderTop', value), ...this.parseBorderSide('borderBottom', value) };
  },

  parseBorderSide(prefix, value) {
    const result = {};
    const parts = value.trim().split(/\s+/);
    for (const part of parts) {
      if (/^[\d.]/.test(part)) result[`${prefix}Width`] = part;
      else if (['solid','dashed','dotted','double','none','hidden'].includes(part.toLowerCase())) result[`${prefix}Style`] = part;
      else result[`${prefix}Color`] = part;
    }
    return result;
  },

  expandBackground(value) {
    const result = {};
    if (this.isColor(value)) { result.backgroundColor = value; return result; }
    if (value.includes('linear-gradient')) {
      const gradient = this.parseLinearGradient(value);
      if (gradient) result.backgroundGradient = gradient;
      return result;
    }
    const urlMatch = value.match(/url\([^)]+\)/);
    if (urlMatch) result.backgroundImage = urlMatch[0];
    const colorMatch = value.match(/#[0-9a-fA-F]{3,8}|rgba?\([^)]+\)|[a-z]+/gi);
    if (colorMatch) {
      for (const match of colorMatch) {
        if (this.isColor(match) && match.toLowerCase() !== 'url') {
          result.backgroundColor = match;
          break;
        }
      }
    }
    return result;
  },

  // Parses Luckysheet dataBar format: "linear-gradient(to right, #63c3f5 45%, transparent 45%)"
  parseLinearGradient(value) {
    const match = value.match(/linear-gradient\(\s*to\s+(\w+)\s*,\s*([^,]+?)\s+(\d+(?:\.\d+)?)%\s*,\s*transparent/i);
    if (match) {
      return {
        direction: match[1].trim(),
        color: match[2].trim(),
        percent: parseFloat(match[3]),
      };
    }
    return null;
  },

  expandFont(value) {
    const result = {};
    const parts = value.split(/\s+/);
    for (let i = 0; i < parts.length; i++) {
      const part = parts[i];
      if (['bold','bolder','lighter','normal'].includes(part) || /^\d{3}$/.test(part)) {
        result.fontWeight = part;
      } else if (['italic','oblique'].includes(part)) {
        result.fontStyle = part;
      } else if (/^\d/.test(part)) {
        const sizeMatch = part.match(/^([\d.]+)(px|em|rem|pt|%)?(?:\/([\d.]+)(px|em|rem|pt|%)?)?$/);
        if (sizeMatch) {
          result.fontSize = sizeMatch[1] + (sizeMatch[2] || 'px');
          if (sizeMatch[3]) result.lineHeight = sizeMatch[3] + (sizeMatch[4] || '');
        }
      } else if (part.includes(',') || i === parts.length - 1) {
        result.fontFamily = parts.slice(i).join(' ');
        break;
      }
    }
    return result;
  },

  isColor(value) {
    if (!value) return false;
    if (/^#[0-9a-fA-F]{3,8}$/.test(value)) return true;
    if (/^rgba?\(/.test(value)) return true;
    const namedColors = [
      'black','white','red','green','blue','yellow','orange','purple',
      'pink','brown','gray','grey','cyan','magenta','lime','navy',
      'teal','aqua','fuchsia','silver','maroon','olive','transparent',
    ];
    return namedColors.includes(value.toLowerCase());
  },

  // 1pt = 1.33 logical pixels — must match PT_TO_LOGICAL_PIXELS in table-handler.js
  // 1rem/1em = 16px (browser default root font size)
  parseDimension(value) {
    if (!value) return null;
    const s = String(value).trim();
    // CSS fill-available / stretch → treat as 100%
    if (s === '-webkit-fill-available' || s === 'fill-available' || s === 'stretch') {
      return { value: 100, unit: '%' };
    }
    const match = s.match(/^([\d.]+)(px|%|em|rem|pt|vh|vw)?$/);
    if (match) {
      const num = parseFloat(match[1]);
      const unit = match[2] || 'px';
      if (unit === 'pt')  return { value: Math.round(num * 1.33 * 10) / 10, unit: 'px' };
      if (unit === 'rem') return { value: Math.round(num * 16  * 10) / 10, unit: 'px' };
      if (unit === 'em')  return { value: Math.round(num * 16  * 10) / 10, unit: 'px' };
      return { value: num, unit };
    }
    if (!isNaN(value)) return { value: parseFloat(value), unit: 'px' };
    return null;
  },

  colorToFlutter(color) {
    if (!color) return null;
    color = color.trim();
    if (color.startsWith('#')) {
      let hex = color.slice(1);
      if (hex.length === 3) hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
      if (hex.length === 6) return `Color(0xFF${hex.toUpperCase()})`;
      if (hex.length === 8) return `Color(0x${hex.toUpperCase()})`;
    }
    const rgbaMatch = color.match(/rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*(?:,\s*([\d.]+))?\s*\)/);
    if (rgbaMatch) {
      const r = parseInt(rgbaMatch[1]);
      const g = parseInt(rgbaMatch[2]);
      const b = parseInt(rgbaMatch[3]);
      const a = rgbaMatch[4] !== undefined ? parseFloat(rgbaMatch[4]) : 1;
      return `Color.fromRGBO(${r}, ${g}, ${b}, ${a})`;
    }
    const namedColors = {
      'black':'Colors.black','white':'Colors.white','red':'Colors.red',
      'green':'Colors.green','blue':'Colors.blue','yellow':'Colors.yellow',
      'orange':'Colors.orange','purple':'Colors.purple','pink':'Colors.pink',
      'brown':'Colors.brown','gray':'Colors.grey','grey':'Colors.grey',
      'cyan':'Colors.cyan','teal':'Colors.teal','transparent':'Colors.transparent',
      'navy':'Color(0xFF000080)','lime':'Color(0xFF00FF00)','maroon':'Color(0xFF800000)',
    };
    const lowerColor = color.toLowerCase();
    if (namedColors[lowerColor]) return namedColors[lowerColor];
    return `Color(0xFF000000) /* ${color} */`;
  },

  alignToFlutter(align) {
    const m = {
      'left':'Alignment.centerLeft','center':'Alignment.center',
      'right':'Alignment.centerRight','justify':'Alignment.centerLeft',
    };
    return m[align?.toLowerCase()] || null;
  },

  valignToFlutter(valign) {
    const m = {
      'top':'TableCellVerticalAlignment.top','middle':'TableCellVerticalAlignment.middle',
      'bottom':'TableCellVerticalAlignment.bottom','baseline':'TableCellVerticalAlignment.baseline',
    };
    return m[valign?.toLowerCase()] || null;
  },

  textAlignToFlutter(align) {
    const m = {
      'left':'TextAlign.left','start':'TextAlign.left',
      'center':'TextAlign.center',
      'right':'TextAlign.right','end':'TextAlign.right',
      'justify':'TextAlign.justify',
    };
    return m[align?.toLowerCase()] || null;
  },

  textDecorationToFlutter(value) {
    if (!value) return null;
    const hasUnderline   = value.includes('underline');
    const hasLineThrough = value.includes('line-through');
    if (hasUnderline && hasLineThrough)
      return 'TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])';
    if (hasLineThrough) return 'TextDecoration.lineThrough';
    if (hasUnderline)   return 'TextDecoration.underline';
    if (value.includes('none')) return 'TextDecoration.none';
    return null;
  },

  textDecorationStyleToFlutter(value) {
    if (!value) return null;
    if (value.includes('double')) return 'TextDecorationStyle.double';
    if (value.includes('dashed')) return 'TextDecorationStyle.dashed';
    if (value.includes('dotted')) return 'TextDecorationStyle.dotted';
    if (value.includes('wavy'))   return 'TextDecorationStyle.wavy';
    return null;
  },

  fontWeightToFlutter(value) {
    if (!value) return null;
    if (value === 'bold' || value === 'bolder') return 'FontWeight.bold';
    if (value === 'normal') return 'FontWeight.normal';
    const map = {
      '100':'FontWeight.w100','200':'FontWeight.w200','300':'FontWeight.w300',
      '400':'FontWeight.w400','500':'FontWeight.w500','600':'FontWeight.w600',
      '700':'FontWeight.w700','800':'FontWeight.w800','900':'FontWeight.w900',
    };
    return map[String(value)] || null;
  },

  borderSideToFlutter(prefix, styles) {
    const width  = styles[`${prefix}Width`];
    const color  = styles[`${prefix}Color`];
    const style  = styles[`${prefix}Style`];
    if (!width && !color) return null;
    if (style === 'none' || style === 'hidden') return null;
    const w = this.parseDimension(width || '1px')?.value ?? 1;
    if (w === 0) return null;
    const c = color ? this.colorToFlutter(color) : 'Colors.black';
    return `BorderSide(color: ${c}, width: ${w})`;
  },

  cellBorderToFlutter(styles) {
    const top    = this.borderSideToFlutter('borderTop', styles);
    const right  = this.borderSideToFlutter('borderRight', styles);
    const bottom = this.borderSideToFlutter('borderBottom', styles);
    const left   = this.borderSideToFlutter('borderLeft', styles);
    if (!top && !right && !bottom && !left) return null;
    const parts = [];
    if (top)    parts.push(`top: ${top}`);
    if (right)  parts.push(`right: ${right}`);
    if (bottom) parts.push(`bottom: ${bottom}`);
    if (left)   parts.push(`left: ${left}`);
    return `Border(${parts.join(', ')})`;
  },

  // border-collapse: avoid double lines by shared-edge rule.
  // Each cell draws right+bottom. top/left only when:
  //   - it's the first row/col (outer edge), OR
  //   - the cell has an explicit heavier/different border on that side (separator lines).
  cellBorderCollapsed(styles, isFirstRow, isFirstCol) {
    const sides = [];
    const top    = this.borderSideToFlutter('borderTop', styles);
    const left   = this.borderSideToFlutter('borderLeft', styles);
    const right  = this.borderSideToFlutter('borderRight', styles);
    const bottom = this.borderSideToFlutter('borderBottom', styles);

    // In collapsed mode each cell draws bottom+right only.
    // Top drawn only for first row (outer edge); left only for first col.
    // This prevents doubled borders at shared edges.
    if (top && isFirstRow) sides.push(`top: ${top}`);
    if (left && isFirstCol) sides.push(`left: ${left}`);
    if (right)  sides.push(`right: ${right}`);
    if (bottom) sides.push(`bottom: ${bottom}`);
    if (sides.length === 0) return null;
    return `Border(${sides.join(', ')})`;
  },
};

if (typeof window !== 'undefined') window.StyleParser = StyleParser;
if (typeof module !== 'undefined') module.exports = StyleParser;
