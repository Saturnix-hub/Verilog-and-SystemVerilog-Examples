module test;

  int mem[int];   // associative array

  int idx;

  initial begin
    // insert values
    mem[10] = 100;
    mem[20] = 200;
    mem[30] = 300;

    // exists()
    $display("exists(20) = %0d", mem.exists(20)); // 1
    $display("exists(40) = %0d", mem.exists(40)); // 0

    // first()
    if (mem.first(idx))
      $display("first index = %0d", idx);

    // last()
    if (mem.last(idx))
      $display("last index = %0d", idx);

    // next()
    idx = 10;
    if (mem.next(idx))
      $display("next index after 10 = %0d", idx);

    // prev()
    idx = 30;
    if (mem.prev(idx))
      $display("prev index before 30 = %0d", idx);

    // num()
    $display("number of elements = %0d", mem.num());

    // delete()
    mem.delete(20);
    $display("after delete, exists(20) = %0d", mem.exists(20));

  end

endmodule