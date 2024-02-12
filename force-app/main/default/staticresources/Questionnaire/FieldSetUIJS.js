/**
 * This JavaScript file is created to apply
 * additional functionalities to the 
 * 'FieldSetUIGeneratorController' page.
 * 
 * @author      Shruti Sridharan
 * @since       05/09/2016
 * @revisions   N/A
 */
var FieldSetUI = {
    constants : {
        selectors : {
            INPUT           : "input[type='text'],input[type='checkbox'],select,textarea",
            ANCHOR          : "a",
            SLDS_INPUT      : "input[type='text'],select,textarea",
            MULTI_SELECT    : "select[multiple='multiple']"
        },
        classes : {
            SLDS_INPUT  : "slds-input"
        }
    },
    
    helpers : {
        /**
         * This function is created to apply
         * 'slds-input' classes to all the
         * input tags.
         */
        applySLDS : function() {
            var constants   = FieldSetUI.constants;
            var helpers     = FieldSetUI.helpers;
            
            $( constants.selectors.SLDS_INPUT ).addClass( constants.classes.SLDS_INPUT );
            
            helpers.showElements();
        },
        /**
         * This function is created to apply
         * Selectize Library to the Multi-
         * Picklist Fields.
         */
        applySelectize : function() {
            var constants   = FieldSetUI.constants;
            
            $( constants.selectors.MULTI_SELECT )
                .removeClass( constants.classes.SLDS_INPUT )
                .selectize(
                    {
                        maxItems: null
                    }
                );
        },
        /**
         * This function is created to show the
         * input boxes because initially the 
         * input boxes gets loaded without 
         * the 'slds-input' class being applied
         * as this class is being applied via JS.
         */
        showElements : function() {
            var constants = FieldSetUI.constants;
            
            $( constants.selectors.INPUT ).fadeIn();
            $( constants.selectors.ANCHOR ).fadeIn();
        }
    },
    
    actions : {
        
    },
    
    init : function() {
        FieldSetUI.helpers.applySLDS();
        FieldSetUI.helpers.applySelectize();
    }
};

FieldSetUI.init();