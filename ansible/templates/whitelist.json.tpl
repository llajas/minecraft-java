[
{% for player in players %}
  {
    "uuid": "{{ player.uuid }}",
<<<<<<< HEAD
    "name": "{{ player.name }}",
=======
    "name": "{{ player.name }}"
>>>>>>> origin/main
  }{% if not loop.last %},{% endif %}
{% endfor %}
]
