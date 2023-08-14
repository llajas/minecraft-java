[
{% for player in players %}
  {
    "uuid": "{{ player.uuid }}",
    "name": "{{ player.name }}",
    "level": 4
  }{% if not loop.last %},{% endif %}
{% endfor %}
]

