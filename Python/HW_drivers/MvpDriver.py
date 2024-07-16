from pynq import DefaultIP
class MvpDriver(DefaultIP):
    def __init__(self, description):
        """
        All methods from Xilinx's Overlay class are inherited.
        """
        super().__init__(description)
        self._MVP_ADDR   = 0x00 # r/w
        self._MVP_WDATA  = 0x04 # r/w
        self._MVP_RDATA  = 0x08 # r/w
        self._MVP_CONFIG = 0x0c # r/w

        self._CLK_MODE     = 1<<0
        self._CLK_VAL      = 1<<1
        self._PERPH_I_MODE = 1<<2
        self._DATA_MODE    = 1<<3
        self._CAPTURE      = 1<<4
        
    bindto = ["engineering.ucsb.edu:user:Module_Validation_Platform:1.0"]
        
    def _get_config(self):
        return self.read(self._MVP_CONFIG) & 0b11111
    
    def set_clk_mode(self, mode:str):
        """
        This function will set the clock output mode to:
            "global" : sync with global clock
            "reg"    : follow the bit stored in the clock value register
        
        Note: The BRAM uses the same clock defined by the clock mode
        register to allow debugging flexibility. However, when writing
        to the BRAM, clock mode should be set to sync with the global
        clock.
        """
        if type(mode) != str:
            raise TypeError("Clock mode must be of type string")
        if mode == "global":
            config = self._get_config()
            self.write(self._MVP_CONFIG, config & ~self._CLK_MODE)
        elif mode == "reg":
            config = self._get_config()
            self.write(self._MVP_CONFIG, config | self._CLK_MODE)
        else:
            raise ValueError("Clock mode is either \"global\" or \"reg\"")
            
    def set_clk_val(self, val:bool):
        """
        This function sets the clock state. If clock mode is "global",
        this clock state will be ignored.
        """
        if type(mode) != str:
            raise TypeError("Clock value must be of type bool")
        config = self._get_config()
        if val:
            self.write(self._MVP_CONFIG, config | self._CLK_VAL)
        else:
            self.write(self._MVP_CONFIG, config & ~self._CLK_VAL)
            
    def set_input_mode(self, mode:str):
        """
        This function sets the input mode to:
            "rt"      : real time input of width 32 bits
            "capture" : input captured in the register
        """
        if type(mode) != str:
            raise TypeError("Input mode must be of type string")
        if mode == "rt":
            config = self._get_config()
            self.write(self._MVP_CONFIG, config & ~self._PERPH_I_MODE)
        elif mode == "capture":
            config = self._get_config()
            self.write(self._MVP_CONFIG, config | self._PERPH_I_MODE)
        else:
            raise ValueError("Invalid input mode")
            
    def set_memory_mode(self, mode:str):
        """
        This function will set the memory mode to:
            "oreg"   : read/write to the output register
            "bram"   : read/write to the BRAM that is connected to the
                     BRAM port, if hardware is configured to support it.
        """
        if type(mode) != str:
            raise TypeError("Memory mode must be of type string")
        if mode == "oreg":
            config = self._get_config()
            self.write(self._MVP_CONFIG, config & ~self._DATA_MODE)
        elif mode == "bram":
            config = self._get_config()
            self.write(self._MVP_CONFIG, config | self._DATA_MODE)
            # confirm this bit was successfully written
            config = self._get_config()
            if ((config & self._DATA_MODE) == 0):
                raise ValueError("Hardware does not support BRAM mode")
        else:
            raise ValueError("Invalid memory mode")
    
    def capture(self):
        """
        This function will capture the input to the module validation
        platform and store them in an internal register to be read.
        """
        config = self._get_config()
        self.write(self._MVP_CONFIG, config | self._CAPTURE)
        # This bit automatically resets
        
    def read_mem(self, addr:int)->int:
        """
        This function reads the data port and returns its content.
        If memory mode is set to "oreg" then the output register
        will be read. If memory mode is set to "bram" then the bram
        content will be read. The address must be 4-byte aligned if
        reading from the BRAM.
        """
        if type(addr) != int:
            raise TypeError("Address must be of type int")
        self.write(self._MVP_ADDR, addr)
        return self.read(self._MVP_WDATA)
    
    def write_mem(self, addr:int, val:int):
        """
        This function writes to the data port.
        If memory mode is set to "oreg" then the output register
        will be written. If memory mode is set to "bram" then the
        BRAM will be written. The address must be 4-byte aligned.
        """
        if type(addr) != int:
            raise TypeError("Address must be of type int")
        if type(val) != int:
            raise TypeError("Write value must be of type int")
        self.write(self._MVP_ADDR, addr)
        self.write(self._MVP_WDATA, val)
    
    def read_input(self, addr:int)->int:
        """
        This function reads the input port and returns its content.
        If input mode is set to "rt" then the input lines will be
        read directly. If input mode is set to "capture" then the
        capture register content will be read.
        """
        return self.read(self._MVP_RDATA)
    
    def read_oreg(self, addr:int)->int:
        """
        This function reads from output register memory space and
        returns the vlaue.
        """
        self.set_memory_mode("oreg")
        return self.read_mem(addr)
    
    def read_BRAM(self, addr:int)->int:
        """
        This function reads from BRAM memory space and returns the
        vlaue.
        The address must be 4-byte aligned.
        """
        config = self._get_config()
        self.set_clk_mode("global")
        self.set_memory_mode("bram")
        ret_data = self.read_mem(addr)
        self.write(self._MVP_CONFIG, config)
        return ret_data
    
    def write_oreg(self, addr:int, val:int):
        """
        This function writes to the output registers memory space.
        """
        self.set_memory_mode("oreg")
        return self.write_mem(addr, val)
    
    def write_BRAM(self, addr:int, val:int):
        """
        This function writes to the BRAM memory space.
        The address must be 4-byte aligned.
        """
        config = self._get_config()
        self.set_clk_mode("global")
        self.set_memory_mode("bram")
        self.write_mem(addr, val)
        self.write(self._MVP_CONFIG, config)
    
    def read_captured_input(self, addr:int)->int:
        """
        This function returns the last captured input.
        """
        self.set_input_mode("capture")
        return self.read_input(addr)
        
    def read_rt_input(self, addr:int)->int:
        """
        This function returns the real time input.
        """
        self.set_input_mode("rt")
        return self.read_input(addr)