# This is a program that converts an array into a csv format
sub list2csv {
   # Localizing the parameters and making our varibles
   my @list = @_;
   my $csv = "";

   # For each entry in the array
   foreach $entry (@list){
      # If the entry in the array is an array
      if (ref($entry) eq "ARRAY"){
         # Go through each of the elements in the inbedded array
         foreach $cell (@$entry) {
            # Format " as ""
            $cell =~ s/"/""/g;
            # If the value contains a \n or , we want to wrap
            # the element with quotation marks
            $cell =~ s/^(.*)([\n,])(.*)$/"$1$2$3"/g;
            # Add a comma to separate the values
            $csv .= $cell.",";
         }
         # Remove the comma from the end of the string and add a new line
         chop($csv);
         $csv.='\n,';
      }else{
         # If we are working with a 1d array
         # Format " as ""
         $entry =~ s/"/""/g;
         # If the value contains a \n or , we want to wrap
         # the element with quotation marks
         $entry =~ s/^(.*)([\n|,])(.*)$/"$1$2$3"/g;
         # Add a comma to separate the values
         $csv .= $entry.",";
      }
   }
   # Remove the trailing comma on the string
   chop($csv);
   return $csv;
}
