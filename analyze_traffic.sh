#!/bin/bash

# Bash Script to Analyze Network Traffic

pcap_file=$1

# Check if the pcap file path is provided
if [ -z "$pcap_file" ]; then
  echo "Usage: $0 path_to_pcap_file"
  exit 1
fi

# Function to extract information from the pcap file
analyze_traffic() {
  echo "Analyzing traffic in file: $pcap_file"
  
  # Count total packets
  total_packets=$(tshark -r "$pcap_file" | wc -l)
  
  # Count HTTP packets
  http_packets=$(tshark -r "$pcap_file" -Y http | wc -l)
  
  # Count HTTPS/TLS packets
  https_packets=$(tshark -r "$pcap_file" -Y tls | wc -l)
  
  # Get top 5 source IP addresses
  top_source_ips=$(tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -n 5)
  
  # Get top 5 destination IP addresses
  top_dest_ips=$(tshark -r "$pcap_file" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -n 5)
  
  # Output analysis summary
  echo "----- Network Traffic Analysis Report -----"
  echo "1. Total Packets: $total_packets"
  echo "2. Protocols:"
  echo "  - HTTP: $http_packets packets"
  echo "  - HTTPS/TLS: $https_packets packets"
  echo ""
  echo "3. Top 5 Source IP Addresses:"
  echo "$top_source_ips"
  echo ""
  echo "4. Top 5 Destination IP Addresses:"
  echo "$top_dest_ips"
  echo ""
}

# Run the analysis function
analyze_traffic

