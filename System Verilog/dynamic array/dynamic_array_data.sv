module dynamic_array_data();

// Declare dynamic array
reg [7:0] mem [];

initial begin
	
	// first checking the size of an existing array
	$display("\nSize of an existing array : %d\n",mem.size());

  // Allocate array for 4 locations
  $display ("\nSetting array size to 4\n");
  mem = new[4];
  $display("\nInitial the array with default values\n");
  for (int i = 0; i < 4; i ++) begin
    mem[i] = i;
  end
  // Doubling the size of array, with old content still valid
  mem = new[8] (mem);
  // Print current size
  $display ("\nCurrent array size is %d\n",mem.size());
  for (int i = 0; i < 4; i ++) begin
    $display ("\nValue at location %g is %d \n", i, mem[i]);
  end
  // Delete array
  $display ("Deleting the array\n");
  mem.delete();
  $display ("Current array size is %d\n",mem.size());
  #1 $finish;
end

endmodule
