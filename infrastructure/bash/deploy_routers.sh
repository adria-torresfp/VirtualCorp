#!/usr/bin/env bash

set -e

# Carregar les funcions d'ajuda
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/router_base.sh"


check_prerequisites

# Crea el template pel router
# create_router_template

# Topologia adaptada a la delegacion 27

# Router 0: planta baja, zona privada, DMZ, enlace y taller
create_router "mikrotik0" 2200 \
  --intnets "pl0" "privada" "dmz" "r0-r1" "taller" \
  --ips "10.27.0.1/25" "10.27.0.129/26" "10.27.0.193/27" "10.27.0.225/30" "10.0.2.1/24" \
  --nat

# Router 1: enlace con router 0, planta 1 y enlace con router 2
create_router "mikrotik1" 2201 \
  --intnets "r0-r1" "pl1" "r1-r2" \
  --ips "10.27.0.226/30" "10.27.1.1/24" "10.27.0.229/30" \
  --gateway "10.27.0.225"

# Router 2: enlace con router 1, planta 2 y enlace con router 3
create_router "mikrotik2" 2202 \
  --intnets "r1-r2" "pl2" "r2-r3" \
  --ips "10.27.0.230/30" "10.27.2.1/24" "10.27.0.233/30" \
  --gateway "10.27.0.229"

# Router 3: enlace con router 2 y planta 3a
create_router "mikrotik3" 2203 \
  --intnets "r2-r3" "pl3" \
  --ips "10.27.0.234/30" "10.27.3.1/25" \
  --gateway "10.27.0.233"

log_info "=========================================="
log_info "[+] Routers desplegats correctament."
log_info "=========================================="
