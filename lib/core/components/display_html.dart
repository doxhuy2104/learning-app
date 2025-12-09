import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:learning_app/modules/app/presentation/pages/questions_page.dart'
    as questions_page;

class DisplayHtml extends StatelessWidget {
  final String htmlContent;
  final double? maxWidth;
  final double fontSize;

  const DisplayHtml({
    Key? key,
    required this.htmlContent,
    this.maxWidth,
    this.fontSize = 16,
  }) : super(key: key);

  // Helper function to process LaTeX blocks
  String _processLatex(String html) {
    String processed = html;

    // Replace \[...\] (display math) with <tex>...</tex>
    processed = processed.replaceAllMapped(
      RegExp(r'\\\[(.*?)\\\]', dotAll: true),
      (match) => '<tex>${match.group(1) ?? ''}</tex>',
    );

    // Replace \(...\) (inline math) with <tex-inline>...</tex-inline>
    processed = processed.replaceAllMapped(
      RegExp(r'\\\((.*?)\\\)', dotAll: true),
      (match) => '<tex-inline>${match.group(1) ?? ''}</tex-inline>',
    );

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveMaxWidth = maxWidth ?? (screenWidth - 32);
    final processedContent = _processLatex(htmlContent);

    return Html(
      data: processedContent,
      extensions: [
        // Handle display math (\[...\])
        TagExtension(
          tagsToExtend: {"tex"},
          builder: (extensionContext) {
            return Math.tex(
              extensionContext.innerHtml,
              textStyle: TextStyle(fontSize: fontSize + 2),
            );
          },
        ),
        // Handle inline math (\(...\))
        TagExtension(
          tagsToExtend: {"tex-inline"},
          builder: (extensionContext) {
            return Math.tex(
              extensionContext.innerHtml,
              textStyle: TextStyle(fontSize: fontSize),
            );
          },
        ),
        // Handle MathML
        TagExtension(
          tagsToExtend: {"math"},
          builder: (extensionContext) {
            final mathmlContent = extensionContext.innerHtml;
            final latex = questions_page.mathmlToLatex(mathmlContent);
            return Math.tex(latex, textStyle: TextStyle(fontSize: fontSize));
          },
        ),
        // Handle images - limit to screen width
        TagExtension(
          tagsToExtend: {"img"},
          builder: (extensionContext) {
            final src = extensionContext.attributes['src'] ?? '';
            if (src.isEmpty) {
              return const SizedBox.shrink();
            }

            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
              child: Image.network(
                src,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
        // Handle tables using flutter_html_table with custom wrapper for scrolling
        TagExtension(
          tagsToExtend: {"table"},
          builder: (extensionContext) {
            // Get table attributes
            final tableAttributes = extensionContext.attributes.entries
                .map((e) => '${e.key}="${e.value}"')
                .join(' ');
            final tableHtml = tableAttributes.isNotEmpty
                ? '<table $tableAttributes>${extensionContext.innerHtml}</table>'
                : '<table>${extensionContext.innerHtml}</table>';

            // Wrap table in SingleChildScrollView for horizontal scrolling
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
                  child: Html(
                    data: tableHtml,
                    extensions: [
                      const TableHtmlExtension(),
                      // Also handle LaTeX in table cells
                      TagExtension(
                        tagsToExtend: {"tex"},
                        builder: (ctx) {
                          return Math.tex(
                            ctx.innerHtml,
                            textStyle: TextStyle(fontSize: fontSize - 2),
                          );
                        },
                      ),
                      TagExtension(
                        tagsToExtend: {"tex-inline"},
                        builder: (ctx) {
                          return Math.tex(
                            ctx.innerHtml,
                            textStyle: TextStyle(fontSize: fontSize - 2),
                          );
                        },
                      ),
                      TagExtension(
                        tagsToExtend: {"math"},
                        builder: (ctx) {
                          final mathmlContent = ctx.innerHtml;
                          final latex = questions_page.mathmlToLatex(
                            mathmlContent,
                          );
                          return Math.tex(
                            latex,
                            textStyle: TextStyle(fontSize: fontSize - 2),
                          );
                        },
                      ),
                    ],
                    style: {
                      "table": Style(
                        display: Display.block,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      "td": Style(
                        padding: HtmlPaddings.all(8),
                        fontSize: FontSize(fontSize - 2),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      "th": Style(
                        padding: HtmlPaddings.all(8),
                        fontSize: FontSize(fontSize - 2),
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      "tr": Style(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
      style: {
        "p": Style(
          textAlign: TextAlign.left,
          color: Colors.black,
          fontSize: FontSize(fontSize),
        ),
        "span": Style(color: Colors.black, fontSize: FontSize(fontSize)),
        "strong": Style(fontWeight: FontWeight.bold),
        "div": Style(textAlign: TextAlign.left, color: Colors.black),
        // Table styles - TableHtmlExtension will handle rendering
        "table": Style(
          display: Display.block,
          border: Border.all(color: Colors.grey, width: 1),
          margin: Margins.symmetric(vertical: 8),
          width: Width(effectiveMaxWidth),
        ),
        "td": Style(
          padding: HtmlPaddings.all(8),
          fontSize: FontSize(fontSize - 2),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          textAlign: TextAlign.center,
        ),
        "th": Style(
          padding: HtmlPaddings.all(8),
          fontSize: FontSize(fontSize - 2),
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          textAlign: TextAlign.center,
        ),
        "tr": Style(border: Border.all(color: Colors.grey.shade300, width: 1)),
      },
    );
  }
}
