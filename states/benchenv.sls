include:
  - user
  - makeenv

perfrun.sh:
  file.managed:
    - user: test
    - name: /home/test/perfrun.sh
    - mode: 755
    - source: salt://files/perfrun.sh
    - require:
      - Test user

batchbench.sh:
  file.managed:
    - user: test
    - name: /home/test/batchbench.sh
    - mode: 755
    - source: salt://files/batchbench.sh
    - require:
      - Test user

batchperfrun.sh:
  file.managed:
    - user: test
    - name: /home/test/batchperfrun.sh
    - mode: 755
    - source: salt://files/batchperfrun.sh
    - require:
      - Test user

batchbench.revs:
  file.managed:
    - user: test
    - name: /home/test/batchbench.revs
    - contents: |
        10c4f9b1b2476f71159fa5569d9238001760404c
        9e9db08b874fe7c1200aafd95fe6bccd41148ae5
        fa7973a4ef99b0d91122d16ffee51744288d037f
        2988c5bb07c4a5ad434855413f20fec11008c818
        63bef3d142b2ae25ed42d344c40729fb5f3d552e
    - require:
      - Test user

report.lua:
  file.managed:
    - user: test
    - name: /home/test/report.lua
    - contents: |
        done = function(summary, latency, requests)
           io.write(string.format("latency.avg: %.2f\n", latency.mean/1000))
           io.write(string.format("rps: %.2f\n", summary.requests/(summary.duration/1000000)))
        end
    - require:
      - Test user
