extends Node

signal card_select_toggle(card: Card)
signal draw_card(deck: Deck)
signal play_cards(primary: Card, costs: Array[Card], targets: Array[Card])
signal cards_playable(playable: bool)

signal turn_began(combatant: Combatant)
signal turn_ended(combatant: Combatant)
signal card_chown_requested(card: Card, to: Global.zone_types)
