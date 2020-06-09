param (
[Parameter(ValueFromPipeline=$true)][string[]]$text,
[Parameter(Mandatory=$true,
	HelpMessage="Path to Xtensa addr2line program.")][string]$addr2line,
[Parameter(Mandatory=$true,
	HelpMessage="Path to ELF binary.")][string]$elf,
[Parameter()][string]$trace
)
begin
{
	function show-help {
			write-output "`nUsage:"
			write-output "$(split-path -leaf $pscommandpath) -addr2line <path to Xtensa addr2line> -elf <path to ELF file> -trace <path to exception output>"
			write-output "`nException output file may be replaced by pipeline input`n"
	}
	
	if($trace.length -gt 0)
	{
		$text = gc $trace
	}
	
	$program = (resolve-path $addr2line).path
	$arguments = @("-aipfC", "-e", (resolve-path $elf).path)
}
process {
	if ($text -eq $null)
	{
		show-help
		exit
	}

	$results = $text | select-string "0x(4[0-9a-f]{7}):" -allmatches
	if($results.count -gt 0)
	{
		foreach ($res in $results[0].matches) {
			$arguments += $res.groups[1].value
		}
	}
}
end
{
	start-process -filepath $program -argumentlist $arguments -nonewwindow -wait
}
