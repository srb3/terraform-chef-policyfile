name '${name}'

default_source ${default_source}

run_list ${jsonencode(runlist)}

%{ for cookbook in keys(cookbooks) }
cookbook '${ cookbook }'${cookbooks[cookbook] != "" ? ", ${cookbooks[cookbook]}" : ""}
%{ endfor }
