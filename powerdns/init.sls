{% from "powerdns/map.jinja" import powerdns with context %}

{% set os_family = salt['grains.get']('os_family') %}

{% if powerdns.repo.install_from_repo and os_family in ['Debian', 'RedHat'] %}
include:
  - powerdns.repo
{% endif %}

powerdns:
  pkg.installed:
    - name: {{ powerdns.lookup.pkg }}
    - refresh_db: True
    {% if powerdns.repo.install_from_repo and os_family in ['Debian', 'RedHat'] %}
    - require:
      - sls: powerdns.repo
    {% endif %}

  service.running:
    - name: {{ powerdns.lookup.service }}
    - enable: True
    - require:
      - pkg: powerdns
