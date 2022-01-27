
sub csv2list {
   my $csvString = shift;                 # The inputted csv String
   my @csvList;                           # An empty array for splitting the csv String
   my $specialChar1 = chr(14).chr(15);    # A location token for the "" character
   my $specialChar2 = chr(00).chr(07);    # A location token for the , character when in an element
   my $specialChar3 = chr(14).chr(07);    # A location token for the \n character when in an element
   my @return;                            # An array to hold the return List

   # First we replace the ""  token with the special character
   # Second we replace the \n token with the special character
   # We hide these values because they are delimeters in our splits
   # we will return them after separating the strings

   $csvString =~ s/""/$specialChar1/g;
   $csvString =~ s/(,".*)\n(.*",)/$1$specialChar3$2/g;
   $csvString =~ s/(^".*)\n(.*",)/$1$specialChar3$2/g;
   $csvString =~ s/(,".*)\n(.*"$)/$1$specialChar3$2/g;

   # We then split the string an array around the \n characters not wrapped with a " character
   my @csvList = split("\n,",$csvString);

   foreach my $csvLine (@csvList) {
      my @row;
      # We then replace the , that is between a ," and a ", so that we can split into an
      # array using the , character
      $csvLine =~ s/(,".*),(.*",)/$1$specialChar2$2/g;
      $csvLine =~ s/(^".*),(.*",)/$1$specialChar2$2/g;
      $csvLine =~ s/(,".*),(.*"$)/$1$specialChar2$2/g;

      # If there are unquoted commas that means we are dealing with a 2d csv
      # This requires us to split the elements into individual cells using the
      # , character as a delimeter
      if($csvLine =~ m/,/){
         @csvListIn = split(",",$csvLine);

         # Now that the characters are separated element wise
         # We can return the special characters back to their original forms
         # and remove the extra quotes around the literal strings
         foreach my $element (@csvListIn){
            $element =~ s/"//g;
            $element =~ s/$specialChar2/,/g;
            $element =~ s/$specialChar1/"/g;
            $element =~ s/$specialChar3/\n/g;

            # Once the original state of the strings have been restored
            # We push the element onto a temporary array to be added to
            # the return array
            push(@row, $element);
         }
         push(@return, \@row);
      }else{
         # If we are dealing with the 1d csv file
         # we can replace the characters and return the list
         $csvLine =~ s/"//g;
         $csvLine =~ s/$specialChar2/,/g;
         $csvLine =~ s/$specialChar1/"/g;
         $csvLine =~ s/$specialChar3/\n/g;
         push (@return, $csvLine);
      }
   }
   return @return;
}

