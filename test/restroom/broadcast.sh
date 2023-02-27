#!/bin/bash
source ./test/restroom/functions.sh

[ "$#" = "2" ] || {
    >&2 echo "$0 domain context"
	exit 1
}
domain=$1
ctx=$2
tmpreq=`mktemp`

echo ""
echo "### BROADCAST ###"
# admin
echo ""
echo "CREATE NEW ADMINS"
# all the levels that will try to broadcast other dids
create_admin test-broadcast-service-keyring.json

create_request  ${domain}_A-keyring.json \
                ${domain}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}-keyring.json \
                ${domain} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

# create an admin broadcast later
create_admin test-broadcast-2-service-keyring.json
rm -f service-admin-did.json
echo ""
echo "SIMULATE ALL THE BROADCAST for ${domain} domain"
## Admin
# create did docs to be broadcast from admin
create_request  spec_A-keyring.json \
                ${domain}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}.${ctx}_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec-keyring.json \
                ${domain} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "does not broadcast" "admin"
broadcast_request  test-broadcast-2-service-keyring.json \
                admin \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "broadcasts" "${domain}_A"
broadcast_request  spec_A-keyring.json \
                ${domain}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "broadcasts" "${domain}.${ctx}_A"
broadcast_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "broadcasts" "${domain}.${ctx}"
broadcast_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "broadcasts" "${domain}"
broadcast_request  spec-keyring.json \
                ${domain} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

rm -f secrets/spec*

## domain admin (domain_A)
# create did docs to be broadcast from domain admin
create_request  spec_A-keyring.json \
                ${domain}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec-keyring.json \
                ${domain} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not broadcast" "admin"
broadcast_request  test-broadcast-2-service-keyring.json \
                admin \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not broadcast" "${domain}_A"
broadcast_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "broadcasts" "${domain}.${ctx}_A"
broadcast_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "broadcasts" "${domain}.${ctx}"
broadcast_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "broadcasts" "${domain}"
broadcast_request  spec-keyring.json \
                ${domain} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

rm -f secrets/spec.ctx_A-keyring.json secrets/spec.ctx-keyring.json secrets/spec-keyring.json

## domain.context admin (domain.ctx_A)
# create did docs to be broadcast from domain context admin
# (spec admin is still active so no need to create a new one)
create_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec-keyring.json \
                ${domain} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not broadcast" "admin"
broadcast_request  test-broadcast-2-service-keyring.json \
                admin \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not broadcast" "${domain}_A"
broadcast_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not broadcast" "${domain}.${ctx}_A"
broadcast_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "broadcasts" "${domain}.${ctx}"
broadcast_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not broadcast" "${domain}"
broadcast_request  spec-keyring.json \
                ${domain} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

rm -f secrets/spec.ctx-keyring.json

## domain.context (domain.ctx)
# create did docs to be broadcast from domain context
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-broadcast-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}.${ctx}_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not broadcast" "admin"
broadcast_request  test-broadcast-2-service-keyring.json \
                admin \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not broadcast" "${domain}_A"
broadcast_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not broadcast" "${domain}.${ctx}_A"
broadcast_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not broadcast" "${domain}.${ctx}"
broadcast_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not broadcast" "${domain}"
broadcast_request  spec-keyring.json \
                ${domain} \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

## domain (domain)
printf "%-18s %-20s %s\n" "${domain}" "does not broadcast" "admin"
broadcast_request  test-broadcast-2-service-keyring.json \
                admin \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not broadcast" "${domain}_A"
broadcast_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not broadcast" "${domain}.${ctx}_A"
broadcast_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not broadcast" "${domain}.${ctx}"
broadcast_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not broadcast" "${domain}"
broadcast_request  spec-keyring.json \
                ${domain} \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-broadcast.chain ${tmpreq} 255
rm -f ${tmpreq}


