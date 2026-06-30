extends Node

signal card_select_toggle(card: Card, selected: bool)
signal draw_card(deck: Deck)

signal turn_began(combatant: Combatant)
signal turn_ended(combatant: Combatant)
