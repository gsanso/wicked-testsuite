Feature: Wicked 3 physical

  In order to be able to set up network interfaces
  As a network administrator using a wide range of hardware
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the network services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: Create an infiniband interface from legacy ifcfg files, datagram mode
    Given infiniband is supported on both machines
    When the reference machine is set up in infiniband ud-nomux mode
    And the reference machine provides dynamic addresses over the infiniband links
    And I create an infiniband interface in ud-nomux mode from legacy files
# TODO incorrect, we always have an ib0 card - check its address
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband interface from wicked XML files, datagram mode
    Given infiniband is supported on both machines
    When the reference machine is set up in infiniband ud-mux mode
    And the reference machine provides dynamic addresses over the infiniband links
    And I create an infiniband interface in ud-mux mode from XML files
# TODO incorrect, we always have an ib0 card - check its address
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband interface from legacy ifcfg files, connected mode
    Given infiniband is supported on both machines
    When the reference machine is set up in infiniband cm-nomux mode
    And the reference machine provides dynamic addresses over the infiniband links
    And I create an infiniband interface in cm-nomux mode from legacy files
# TODO incorrect, we always have an ib0 card - check its address
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband interface from wicked XML files, connected mode
    Given infiniband is supported on both machines
    When the reference machine is set up in infiniband cm-mux mode
    And the reference machine provides dynamic addresses over the infiniband links
    And I create an infiniband interface in cm-mux mode from XML files
# TODO incorrect, we always have an ib0 card - check its address
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband child interface from legacy ifcfg files
    Given infiniband is supported on both machines
    When the reference machine has an infiniband child channel
    And the reference machine provides dynamic addresses over the infiniband links
    And I create an infiniband child interface from legacy files
# TODO correct, but no simple way to skip this test if no infiniband - check the address
#    Then both machines should have a new ib0.8001 card
    And I should be able to ping the other side of the infiniband child link

  Scenario: Create an infiniband child interface from wicked XML files
    Given infiniband is supported on both machines
    When the reference machine has an infiniband child channel
    And the reference machine provides dynamic addresses over the infiniband links
    And I create an infiniband child interface from XML files
# TODO correct, but no simple way to skip this test if no infiniband - check the address
#    Then both machines should have a new ib0.8001 card
    And I should be able to ping the other side of the infiniband child link

  Scenario: Use infiniband bonding
    Given infiniband is supported on both machines
    When the reference machine provides dynamic addresses over the infiniband links
# TODO to be written
# especially dhcp with ib-bond is interesting as the mac changes when bond changes to another nic.
# ask pth at suse.de -- perhaps there is a multiport one and we initialize only 1 port by default.
# other plan: bond(ib0, eth0)
#             bond(ib0.8002, ib0.8003)

# TODO
# ====
#
# Physical (not testable with QEmu)
# * wlan WiFi interfaces
# * isdn telephone interfaces
# * infiniband
# * token ring
# * firewire
# * ctcm s390 mainframes
# * iucv s390 mainframes
#
# Network boot parameters
# * ibft
#
#
# PRIORITIES
# ==========
#
# Important/supported interfaces are, in decreasing order of priority:
#     Ethernet, vlan, bridge, bond
#     ibft, infiniband + child
#     wireless, sit, gre, ipip
#     pppoe

