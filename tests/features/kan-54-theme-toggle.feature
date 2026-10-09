Feature: KAN-54 Light/Dark mode theme toggle

  Background:
    Given the application is available

  Scenario: Default theme is Light for first-time visitors
    Given localStorage key "sms_theme" is cleared
    When I open the application
    Then the "html" element should have attribute "data-theme" with value "light"
    And the element with id "themeToggleBtn" should have accessible label "Dark mode"
    And the element with id "themeToggleBtn" should have attribute "aria-pressed" with value "false"

  Scenario: Toggle to Dark mode via click updates UI state and persistence
    Given localStorage key "sms_theme" is cleared
    And I open the application
    When I click the element with id "themeToggleBtn"
    Then the "html" element should have attribute "data-theme" with value "dark"
    And localStorage key "sms_theme" should equal "dark"
    And the element with id "themeToggleBtn" should have accessible label "Light mode"
    And the element with id "themeToggleBtn" should have attribute "aria-pressed" with value "true"

  Scenario: Toggle back to Light mode via click updates UI state and persistence
    Given localStorage key "sms_theme" is cleared
    And I open the application
    And I click the element with id "themeToggleBtn"
    When I click the element with id "themeToggleBtn"
    Then the "html" element should have attribute "data-theme" with value "light"
    And localStorage key "sms_theme" should equal "light"
    And the element with id "themeToggleBtn" should have accessible label "Dark mode"
    And the element with id "themeToggleBtn" should have attribute "aria-pressed" with value "false"

  Scenario: Persisted Dark theme is applied on reload
    Given localStorage key "sms_theme" is set to "dark"
    When I open the application
    Then the "html" element should have attribute "data-theme" with value "dark"
    And the element with id "themeToggleBtn" should have accessible label "Light mode"
    And the element with id "themeToggleBtn" should have attribute "aria-pressed" with value "true"

  Scenario: Persisted Light theme is applied on reload
    Given localStorage key "sms_theme" is set to "light"
    When I open the application
    Then the "html" element should have attribute "data-theme" with value "light"
    And the element with id "themeToggleBtn" should have accessible label "Dark mode"
    And the element with id "themeToggleBtn" should have attribute "aria-pressed" with value "false"

  Scenario: Theme selection remains stable across navigation within the app
    Given localStorage key "sms_theme" is cleared
    And I open the application
    And I click the element with id "themeToggleBtn"
    When I navigate to another page/route within the application and return
    Then the "html" element should have attribute "data-theme" with value "dark"
    And localStorage key "sms_theme" should equal "dark"

  Scenario: Theme toggle button is keyboard operable (Enter)
    Given localStorage key "sms_theme" is cleared
    And I open the application
    And the element with id "themeToggleBtn" is focused
    When I press the "Enter" key
    Then the "html" element should have attribute "data-theme" with value "dark"
    And localStorage key "sms_theme" should equal "dark"

  Scenario: Theme toggle button is keyboard operable (Space)
    Given localStorage key "sms_theme" is cleared
    And I open the application
    And the element with id "themeToggleBtn" is focused
    When I press the "Space" key
    Then the "html" element should have attribute "data-theme" with value "dark"
    And localStorage key "sms_theme" should equal "dark"

  Scenario: Theme styles apply to background and text
    Given localStorage key "sms_theme" is cleared
    And I open the application
    When I click the element with id "themeToggleBtn"
    Then the page background should reflect the "dark" theme
    And visible text should reflect the "dark" theme

  Scenario: Theme styles apply to cards and table
    Given localStorage key "sms_theme" is cleared
    And I open the application
    When I click the element with id "themeToggleBtn"
    Then all visible cards should reflect the "dark" theme
    And the main data table should reflect the "dark" theme

  Scenario: Theme styles apply to buttons and inputs
    Given localStorage key "sms_theme" is cleared
    And I open the application
    When I click the element with id "themeToggleBtn"
    Then primary and secondary buttons should reflect the "dark" theme
    And text inputs should reflect the "dark" theme

  Scenario: Theme styles apply to dropdowns
    Given localStorage key "sms_theme" is cleared
    And I open the application
    When I click the element with id "themeToggleBtn"
    Then dropdown controls and their opened menu should reflect the "dark" theme
