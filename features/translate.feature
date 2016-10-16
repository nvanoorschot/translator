Feature: Translate
  Background:
    Given the following translations exist
      | locale  | key                   | value                   |
      | en      | model.attributes.key  | en_model_attributes_key |
      | en      | attributes.key        | en_attributes_key       |
      | ch      | attributes.key        | ch_attributes_key       |

  Scenario:
    Given the current locale is ':en'
    When the translation 'model.attributes.key' is requested
    Then it is logged in the @translations variable
