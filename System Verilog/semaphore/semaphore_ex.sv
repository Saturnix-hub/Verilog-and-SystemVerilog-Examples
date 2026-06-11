module semaphore_ex;

  semaphore  semBus = new(1);

  initial begin
    fork 
      agent("AGENT 0",1);
      agent("AGENT 1",2);
    join
  end

  task automatic agent(string name, integer nwait);
    integer i = 0;
    for (i = 0 ; i < 4; i ++ ) begin
      semBus.get();
      $display("[%0d] Lock semBus for %s", $time,name);
      #(nwait);
      $display("[%0d] Release semBus for %s", $time,name);
      semBus.put();
      #(nwait);
    end
  endtask

endmodule 

