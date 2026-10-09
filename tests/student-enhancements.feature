Feature: KAN-41 XLS export and KAN-42 Light/Dark theme

  Scenario: Export all displayed student records to an XLS file
    Given I have one or more student records in the Student Records table
    When I click "Export XLS"
    Then an .xls file named students_YYYY-MM-DD_HHMM.xls is downloaded
    And it has one row per student with Roll No, Name, Email, Course, Grade and Status

  Scenario: Export respects the status filter
    Given I filter Status to "Inactive"
    When I click "Export XLS"
    Then only inactive students are in the file

  Scenario: Empty state export
    Given no student records match the table
    When I click "Export XLS"
    Then no file is downloaded
    And I see "No data to export."

  Scenario: App loads in Light Mode by default
    Given I open the app in a new browser session
    Then the UI is in Light Mode and the toggle offers "Dark Mode"

  Scenario: Toggle and persist theme
    Given the app is in Light Mode
    When I click the theme toggle
    Then the UI is in Dark Mode
    When I refresh the page
    Then the app is still in Dark Mode
    When I click the theme toggle
    Then the UI is in Light Mode

  Scenario: Theme does not affect data
    Given the table shows 3 students
    When I toggle the theme
    Then the table and metrics are unchanged
