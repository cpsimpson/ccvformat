# Changes

## 2026-10-05

- Tightened thesis metadata spacing and removed the extra line break.
- Disabled HTML serializer indentation to avoid introducing blank lines
  into descriptions styled with white-space: pre-line.

- Added a thesis layout supporting both Thesis/Dissertation and Dissertations.
  Reads university/location attributes and retains all populated metadata,
  descriptions, translations, URL, DOI and contribution information.

- Formatted Community and Volunteer Activities like work experience:
  role, organization, dates and multiline activity description.

- Included previously omitted academic Work Description and affiliation
  Activity Description beneath their entries in HTML and LaTeX.
- Added resume-style non-academic roles: title, employer, dates/status,
  and multiline description; also renders descriptions in LaTeX.
- Added `ccv2html --clean` to omit Personal Information, blank fields and
  empty language variants, and fill blank Organization from Other Organization.
- Added GPL-2.0-or-later screen and print stylesheet.
- Embedded CSS in generated HTML so output is portable.
- Added a proper HTML head, page title and mobile viewport.
- Styled fallback sections in normal text; source content is retained.
- Updated installation, usage, attribution and licensing documentation.

Based on Peter Selinger’s ccvformat 0.1 (2015-01-08).
