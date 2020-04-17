include:
  - nginx

python3-pip package:
  pkg.latest:
    - name: python3-pip

{%- for module in ('grpcio', 'protobuf') %}
{{ module }} for python3:
  cmd.run:
    - name: pip3 install {{ module }}
    - unless: pip3 list | grep {{ module }}
    - require:
      - python3-pip package
{%- endfor %}

{%- for f in ('client.py', 'server.py', 'demo.proto', 'demo_pb2_grpc.py', 'demo_pb2.py') %}
/home/test/grpc_data_transmission/{{ f }}:
  file.managed:
    - name: /home/test/grpc_data_transmission/{{ f }}
    - mode: 0644
    - makedirs: True
    - user: test
    - group: test
    - source: salt://files/grpc_data_transmission/{{ f }}
{%- endfor %}

/etc/nginx/conf.d/grpc-proxy.conf:
  file.managed:
    - source: salt://files/etc/nginx/conf.d/grpc-proxy.conf
    - watch_in:
      - service: NGINX service
