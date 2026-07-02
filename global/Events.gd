extends Node

# User operation signals in combat
signal card_select_toggle(card: Card)
signal draw_card(deck: Deck)
signal play_cards(primary: Card, costs: Array[Card], targets: Array[Card])
signal cards_playable(playable: bool)

# Game state signals in combat
signal combatant_entered(combatant: Combatant)
signal turn_began(combatant: Combatant)
signal turn_ended(combatant: Combatant)
signal card_chown_requested(card: Card, to: Global.zone_types)
signal card_select_screen_requested(requester: Card, select_logic: Callable)
