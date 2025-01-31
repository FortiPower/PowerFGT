---
layout: default
title: Documentation
---

# Documentation 📚

The list on cmdlet available

<ul>
{% for file in site.pages %}
  {% if file.path contains 'docs/' and file.path != 'docs/index.md' %}
    <li><a href="{{ file.url }}">{{ file.title | default: file.name }}</a></li>
  {% endif %}
{% endfor %}
</ul>
