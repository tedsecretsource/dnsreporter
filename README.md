# dnsreporter - Generate DNS Reports for a List of Domains

Get DNS records in a CSV format from a file with a list of domains.

`mx.sh --domains 'path/to/sample-domains.txt' --record 'MX' > mxrecords.csv`

If you run a server with more than a trivial amount of domains, you 
sometimes find the need to verify that all the domains are configured 
correctly in DNS. With more than about 10 domains, this can be a very
tedious process.

This script will produce a CSV report showing values for specific 
records in DNS. Simply feed it a list of domains and the record you 
would like to examine, and the script will do the rest. See the 
sample-domains.txt file for an example of the required input format and
sample-mxdomains.csv for an example of the output.

## Sources of inspiration
* https://dev.to/thiht/shell-scripts-matter
* http://redsymbol.net/articles/unofficial-bash-strict-mode/
* https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
