[
{% for player in players %}
  {
    "uuid": "{{ player.uuid }}",
    "name": "{{ player.name }}"
  }{% if not loop.last %},{% endif %}
{% endfor %}
]
