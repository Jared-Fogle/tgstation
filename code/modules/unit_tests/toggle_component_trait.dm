#define TRAIT_TEST "test_trait"
#define TRAIT_HAS_MOCK_ELEMENT "has_mock_element"

/// Test that `toggle_component_trait` properly handles components
/datum/unit_test/toggle_component_trait_components

/datum/unit_test/toggle_component_trait_components/Run()
	var/datum/thing = allocate(/obj/item/pen)
	thing.AddElement( \
		/datum/element/toggle_component_trait, \
		TRAIT_TEST, \
		TOGGLE_COMPONENT_TRAIT_DIRECT, \
		/datum/component/mock_component, \
		100, \
	)

	TEST_ASSERT(isnull(thing.GetComponent(/datum/component/mock_component)), "Component was added before trait")

	ADD_TRAIT(thing, TRAIT_TEST, TRAIT_SOURCE_UNIT_TESTS)

	var/datum/component/mock_component/component = thing.GetComponent(/datum/component/mock_component)
	TEST_ASSERT(!isnull(component), "Component wasn't added when trait was added")
	TEST_ASSERT_EQUAL(component.argument, 100, "Component didn't carry arguments")

	REMOVE_TRAIT(thing, TRAIT_TEST, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(isnull(thing.GetComponent(/datum/component/mock_component)), "Component wasn't removed with trait")

/// Test that `toggle_component_trait` properly handles elements
/datum/unit_test/toggle_component_trait_elements

/datum/unit_test/toggle_component_trait_elements/Run()
	var/datum/thing = allocate(/obj/item/pen)
	thing.AddElement( \
		/datum/element/toggle_component_trait, \
		TRAIT_TEST, \
		TOGGLE_COMPONENT_TRAIT_DIRECT, \
		/datum/element/mock_element, \
		TRAIT_HAS_MOCK_ELEMENT, \
	)

	TEST_ASSERT(!HAS_TRAIT(thing, TRAIT_HAS_MOCK_ELEMENT), "Element was added before trait")

	ADD_TRAIT(thing, TRAIT_TEST, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(HAS_TRAIT(thing, TRAIT_HAS_MOCK_ELEMENT), "Element was not added when trait was added")

	REMOVE_TRAIT(thing, TRAIT_TEST, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(!HAS_TRAIT(thing, TRAIT_HAS_MOCK_ELEMENT), "Element was not removed with trait")

/// Test that `toggle_component_trait` properly handles inverse
/datum/unit_test/toggle_component_trait_inverse

/datum/unit_test/toggle_component_trait_inverse/Run()
	var/datum/thing = allocate(/obj/item/pen)
	thing.AddElement( \
		/datum/element/toggle_component_trait, \
		TRAIT_TEST, \
		TOGGLE_COMPONENT_TRAIT_INVERSE, \
		/datum/element/mock_element, \
		TRAIT_HAS_MOCK_ELEMENT, \
	)

	TEST_ASSERT(HAS_TRAIT(thing, TRAIT_HAS_MOCK_ELEMENT), "Element was not added without trait")

	ADD_TRAIT(thing, TRAIT_TEST, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(!HAS_TRAIT(thing, TRAIT_HAS_MOCK_ELEMENT), "Element was not removed when trait was added")

	REMOVE_TRAIT(thing, TRAIT_TEST, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(HAS_TRAIT(thing, TRAIT_HAS_MOCK_ELEMENT), "Element was not added when trait was removed")

/datum/component/mock_component
	var/argument

/datum/component/mock_component/Initialize(argument)
	src.argument = argument

/datum/element/mock_element
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	var/trait_to_add

/datum/element/mock_element/Attach(datum/source, trait_to_add)
	. = ..()

	if (isnull(trait_to_add))
		CRASH("No argument was passed from toggle_component_trait")

	src.trait_to_add = trait_to_add
	ADD_TRAIT(source, trait_to_add, TRAIT_SOURCE_UNIT_TESTS)

/datum/element/mock_element/Detach(datum/source)
	. = ..()
	REMOVE_TRAIT(source, trait_to_add, TRAIT_SOURCE_UNIT_TESTS)

#undef TRAIT_HAS_MOCK_ELEMENT
#undef TRAIT_TEST
