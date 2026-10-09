@KAN-53 @export @xls
Feature: Export visible student records as XLS
  The user can export the currently visible student records into an .xls file.
  Export must respect active filters (Status + search), export a fixed set of columns
  in the correct order, and name the file with a timestamp.
  The Export button must be disabled when there are no visible rows to export.

  Background:
    Given the Student Management System is running
    And I am on the Students page

  # -------------------------
  # Button enable/disable rules
  # -------------------------

  Scenario: Export button is disabled when there are no student rows visible
    Given there are no student records in the table
    Then the "Export XLS" button with id "exportXlsBtn" should be disabled

  Scenario: Export button is enabled when at least one student row is visible
    Given there is at least 1 student record visible in the table
    Then the "Export XLS" button with id "exportXlsBtn" should be enabled

  Scenario: Export button becomes disabled when a filter results in zero visible rows
    Given there are student records in the system
    And the student table initially shows at least 1 row
    When I apply a Status filter that results in 0 visible rows
    Then the "Export XLS" button with id "exportXlsBtn" should be disabled

  Scenario: Export button becomes enabled again after clearing filters that restore visible rows
    Given there are student records in the system
    And I apply filters so that 0 rows are visible
    And the "Export XLS" button with id "exportXlsBtn" is disabled
    When I clear all filters
    Then the student table should show at least 1 visible row
    And the "Export XLS" button with id "exportXlsBtn" should be enabled

  # -------------------------
  # File naming and extension
  # -------------------------

  Scenario: Exported file is named with the required timestamp format
    Given there is at least 1 student record visible in the table
    When I click the "Export XLS" button with id "exportXlsBtn"
    Then a file download should start
    And the downloaded filename should match the pattern "^students_\\d{4}-\\d{2}-\\d{2}_\\d{2}-\\d{2}\\.xls$"

  Scenario: Exported file uses .xls extension (not .xlsx or other)
    Given there is at least 1 student record visible in the table
    When I click the "Export XLS" button with id "exportXlsBtn"
    Then the downloaded filename should end with ".xls"
    And the downloaded filename should not end with ".xlsx"

  Scenario: Export file timestamp matches the current local time to the nearest minute
    Given there is at least 1 student record visible in the table
    And I record the current date and time in "YYYY-MM-DD_HH-mm" format
    When I click the "Export XLS" button with id "exportXlsBtn"
    Then the downloaded filename should contain the recorded "YYYY-MM-DD_HH-mm" value

  # -------------------------
  # Column requirements (headers + order)
  # -------------------------

  Scenario: Exported XLS contains exactly the required columns in order
    Given there is at least 1 student record visible in the table
    When I export the visible students to XLS
    Then the exported spreadsheet should contain the following columns in this exact order:
      | Roll No   |
      | Name      |
      | Email     |
      | Course    |
      | Grade (%) |
      | Status    |
    And the exported spreadsheet should not contain any additional columns

  Scenario: Exported XLS includes a header row with the required labels
    Given there is at least 1 student record visible in the table
    When I export the visible students to XLS
    Then the first row in the exported spreadsheet should be the header row:
      | Roll No | Name | Email | Course | Grade (%) | Status |

  # -------------------------
  # "Visible rows only" behavior (Status filter + search filter)
  # -------------------------

  Scenario: Export respects the Status filter (only exports visible rows)
    Given the system contains students with Status "Active" and "Inactive"
    When I set the Status filter to "Active"
    Then only students with Status "Active" should be visible in the table
    When I export the visible students to XLS
    Then every exported row should have Status "Active"
    And no student with Status "Inactive" should appear in the exported spreadsheet

  Scenario: Export respects a search filter (only exports visible rows)
    Given the system contains students including a student with Name "Alice Johnson"
    And the student table initially shows multiple rows
    When I search for "Alice"
    Then the table should only show rows matching "Alice"
    When I export the visible students to XLS
    Then the exported spreadsheet should contain only rows matching "Alice"

  Scenario: Export respects combined Status filter and search filter
    Given the system contains:
      | Roll No | Name           | Email              | Course  | Grade (%) | Status   |
      | 101     | Alice Johnson  | alice@test.com     | Math    | 91        | Active   |
      | 102     | Alice Brown    | abrown@test.com    | CS      | 88        | Inactive |
      | 103     | Bob Stone      | bob@test.com       | Math    | 85        | Active   |
    When I set the Status filter to "Active"
    And I search for "Alice"
    Then the table should show exactly 1 visible row
    When I export the visible students to XLS
    Then the exported spreadsheet should contain exactly 1 data row
    And the exported row should be:
      | Roll No | Name          | Email          | Course | Grade (%) | Status |
      | 101     | Alice Johnson | alice@test.com | Math   | 91        | Active |

  Scenario: Export when search filter yields zero results keeps button disabled
    Given the system contains at least 1 student record
    When I search for "text-that-matches-no-student"
    Then the table should show 0 visible rows
    And the "Export XLS" button with id "exportXlsBtn" should be disabled

  # -------------------------
  # Data fidelity and special characters
  # -------------------------

  Scenario: Export preserves special characters in Name and Course fields
    Given the system contains a student:
      | Roll No | Name                | Email                 | Course                 | Grade (%) | Status |
      | 201     | José O’Connor-Singh | jose.oconnor@test.com | C++ & Data-Structures | 97        | Active |
    When I search for "José"
    Then the table should show exactly 1 visible row
    When I export the visible students to XLS
    Then the exported row should preserve the exact text:
      | Name                | Course                 |
      | José O’Connor-Singh | C++ & Data-Structures |

  Scenario: Export preserves email special characters and plus addressing
    Given the system contains a student:
      | Roll No | Name     | Email                     | Course | Grade (%) | Status |
      | 202     | Dev Test | dev.qa+sms_export@test.io | QA     | 100       | Active |
    When I export the visible students to XLS
    Then the exported row should contain Email "dev.qa+sms_export@test.io"
