library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.vga_controller_cfg.all;


architecture behav of tlv_pc_ifc is 
  signal vga_mode: std_logic_vector(60 downto 0);
  signal red: std_logic_vector(2 downto 0);
  signal green: std_logic_vector(2 downto 0);
  signal blue: std_logic_vector(2 downto 0);
  signal sec_jedn : std_logic_vector(8 downto 0);
  signal rgba : std_logic_vector(8 downto 0);
  signal sec_des : std_logic_vector(8 downto 0);
  signal rgbf : std_logic_vector(8 downto 0);

  signal vgaRow: std_logic_vector(11 downto 0);
  signal vgaCol: std_logic_vector(11 downto 0);

  signal sekunda_jednotky : integer range 0 to 9 := 0;
  signal rom_col : integer range 0 to 32;
 

 
 
  signal en_1MHz, en_1Hz, en_50Hz : std_logic;
 
 
  type rozdelovac is array (0 to 14) of std_logic_vector(0 to 31);
  signal rom_rozdelovac: rozdelovac := (
                               "00000000000000000000000000000000",
                               "00000000000000000000000000000000",
                               "00000000001111111111110000000000",
                               "00000000001111111111110000000000",
                               "00000000001111111111110000000000",
                               "00000000001111111111110000000000",
                               "00000000000000000000000000000000",
                               "00000000000000000000000000000000",
                               "00000000000000000000000000000000",
                               "00000000001111111111110000000000",
                               "00000000001111111111110000000000",
                               "00000000001111111111110000000000",
                               "00000000001111111111110000000000",
                               "00000000000000000000000000000000",
                               "00000000000000000000000000000000"
										 );
 
 
  type pamet is array(0 to 16*10-1) of std_logic_vector(0 to 31);

  signal rom_cislic: pamet := (
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",--16
                               "00000000000000111111111111110000",
                               "00000000000000111111111111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111000000000000001111110000",
                               "00001111000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111000000000000001111110000",
                               "00001111000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000011111111111111110000",
                               "00000000000011111111111111110000",
                               "00000000000000000000001111110000",
                               "00001111000000000000001111110000",
                               "00001111000000000000001111110000",
                               "00001111000000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",--16
                               "00001111110000000000000000000000",						   
                               "00001111110000000000000000000000",						   
                               "00001111110000000000000000000000",						   
                               "00001111110000000000000000000000",						   
                               "00001111110000111111000000000000",						   
                               "00001111110000111111000000000000",						   
                               "00001111110000111111000000000000",						   
                               "00001111111111111111111111110000",	
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",							   
                               "00000000000000111111000000000000",
                               "00000000000000111111000000000000",
                               "00000000000000111111000000000000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111110000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000000000000000",
                               (others => '0'),						 
                               "00000000000000000000000000000000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111110000000000001111110000",
                               "00001111111111111111111111110000",
                               "00001111111111111111111111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000001111110000",
                               "00000000000000000000000000000000",
                               (others => '0'));
										 
signal cnt : std_logic_vector(23 downto 0);
signal povol : std_logic;
signal rst: std_logic;

signal rozdelovac_mx : std_logic_vector(0 to 1);
signal sekunda_mx_jedn : std_logic_vector(0 to 1);
signal sekunda_mx_des  : std_logic_vector(0 to 1);

signal  minuta_mx_jedn : std_logic_vector(0 to 1);
signal  minuta_mx_des  : std_logic_vector(0 to 1);

signal  hodina_mx_jedn : std_logic_vector(0 to 1);
signal  hodina_mx_des  : std_logic_vector(0 to 1);

signal sekunda_desitky : integer range 0 to 6 := 0;

signal minuta_jednotky : integer range 0 to 9 := 0;
signal minuta_desitky  : integer range 0 to 6 := 0;

signal hodina_jednotky : integer range 0 to 9 := 0;
signal hodina_desitky  : integer range 0 to 9 := 0;


--- time sync
signal rst_clock: std_logic := '0';
signal clock_ready: std_logic := '0';


-- barvy
signal rgb_min_jedn: std_logic_vector(8 downto 0);
signal rgb_min_des : std_logic_vector(8 downto 0);

signal rgb_hod_jedn : std_logic_vector(8 downto 0);
signal rgb_hod_des  : std_logic_vector(8 downto 0);

-- data out
signal DATA_OUT : std_logic_vector(15 downto 0);


--KEYBOARD
signal kbrd_data_out : std_logic_vector(15 downto 0);
signal kbrd_data_vld : std_logic;

-- stiskla klavesa
signal stiskla_klavesa : integer range 0 to 13;

-- nastaveni cislice
signal kl_potvrd :   integer range 0 to 6;

begin ---------------------------------------------------------------------------------------------------------------------

gen_1mhz: entity work.engen generic map ( MAXVALUE => 39) port map ( CLK => CLK, ENABLE => '1', EN => en_1MHz );
gen_2hz: entity work.engen generic map ( MAXVALUE => 131500*5) port map ( CLK => CLK, ENABLE => en_1MHz, EN => en_1Hz );


-- VGA kontroler
vga: entity work.vga_controller(arch_vga_controller)
  port map(
    CLK => CLK,
    RST => RESET,
    ENABLE => '1',
    MODE => vga_mode,
	 
    DATA_RED => red,
    DATA_GREEN => green,
    DATA_BLUE => blue,
	 
    ADDR_COLUMN => vgaCol,
    ADDR_ROW => vgaRow,
	 
    VGA_RED => RED_V,
    VGA_GREEN => GREEN_V,
    VGA_BLUE => BLUE_V,
	 
    VGA_HSYNC => HSYNC_V,
    VGA_VSYNC => VSYNC_V
  );

-- nastaveni VGA MODU
setmode(r640x480x60, vga_mode);

-- klavesnice
kbrd_ctrl: entity work.keyboard_controller(arch_keyboard)
generic map (READ_INTERVAL => 100000)
port map (
   CLK => CLK,
   RST => RESET,

   DATA_OUT => kbrd_data_out(15 downto 0),
   DATA_VLD => kbrd_data_vld,
   
   KB_KIN   => KIN,
   KB_KOUT  => KOUT
);


-- DATA_OUT(0)  <= kbrd_data_vld='1' and kbrd_data_out(7)='1';
-- DATA_OUT(1)  <= kbrd_data_vld='1' and kbrd_data_out(0)='1';
-- DATA_OUT(2)  <= kbrd_data_vld='1' and kbrd_data_out(4)='1';
-- DATA_OUT(3)  <= kbrd_data_vld='1' and kbrd_data_out(8)='1';
-- DATA_OUT(4)  <= kbrd_data_vld='1' and kbrd_data_out(1)='1';
-- DATA_OUT(5)  <= kbrd_data_vld='1' and kbrd_data_out(5)='1';
-- DATA_OUT(6)  <= kbrd_data_vld='1' and kbrd_data_out(9)='1';
-- DATA_OUT(7)  <= kbrd_data_vld='1' and kbrd_data_out(2)='1';
-- DATA_OUT(8)  <= kbrd_data_vld='1' and kbrd_data_out(6)='1';
-- DATA_OUT(9)  <= kbrd_data_vld='1' and kbrd_data_out(10)='1';
-- DATA_OUT(10) <= kbrd_data_vld='1' and kbrd_data_out(12)='1';
-- DATA_OUT(11) <= kbrd_data_vld='1' and kbrd_data_out(13)='1';
-- DATA_OUT(12) <= kbrd_data_vld='1' and kbrd_data_out(14)='1';
-- DATA_OUT(13) <= kbrd_data_vld='1' and kbrd_data_out(15)='1';
-- DATA_OUT(14) <= kbrd_data_vld='1' and kbrd_data_out(3)='1';
-- DATA_OUT(15) <= kbrd_data_vld='1' and kbrd_data_out(11)='1';

--MX
process(kbrd_data_out,kbrd_data_vld)
begin
 if (kbrd_data_vld='1') then
    case kbrd_data_out(13 downto 0) is
      when "00000010000000" => stiskla_klavesa <= 0;
      when "00000000000001" => stiskla_klavesa <= 1;
      when "00000000010000" => stiskla_klavesa <= 2;
      when "00000100000000" => stiskla_klavesa <= 3;
		when "00000000000010" => stiskla_klavesa <= 4;
		when "00000000100000" => stiskla_klavesa <= 5;
		when "00001000000000" => stiskla_klavesa <= 6;
		when "00000000000100" => stiskla_klavesa <= 7;
		when "00000001000000" => stiskla_klavesa <= 8;
		when "00010000000000" => stiskla_klavesa <= 9;
		when "01000000000000" => stiskla_klavesa <= 12;
		when "10000000000000" => stiskla_klavesa <= 13;
      when others => null;
    end case;
 end if;
end process;


process (CLK,stiskla_klavesa,rst_clock,clock_ready)
variable hour: integer range 0 to 1 := 0;
begin

  if (CLK'event) and (CLK = '1')  then
  
		-- vyvolani resetu
		if kbrd_data_vld='1' and kbrd_data_out(3)='1' then
			rst_clock <= '1';
			clock_ready <= '1';
			kl_potvrd <= 6;
		else
			rst_clock <= '0';
		end if;
  
 		-- reset hodin
		if (rst_clock='1') then
			sekunda_jednotky <= 0;
			sekunda_desitky <= 0;
			
			minuta_jednotky <= 0;
			minuta_desitky <= 0;
			
			hodina_desitky  <= 0;
			hodina_jednotky <= 0;
		end if;
		
		-- hodiny
		if clock_ready = '1' and rst_clock='0' then
				
			--- desitky hodin
			if (kl_potvrd=6) then	
				if kbrd_data_vld='1' and kbrd_data_out(15 downto 0)/="0000000000000000"  and kbrd_data_out(12)='0' and kbrd_data_out(13)='0' then
				
					if stiskla_klavesa=2 and hodina_jednotky<4 then
						hodina_desitky  <= stiskla_klavesa;
					elsif stiskla_klavesa < 2 then
						hodina_desitky  <= stiskla_klavesa;
					end if;
					
				end if;
			end if;
			
			--- hodina po hodine
			if (kl_potvrd=5) then
				if kbrd_data_vld='1' and kbrd_data_out(15 downto 0)/="0000000000000000" and kbrd_data_out(12)='0' and kbrd_data_out(13)='0' then
					if (hodina_desitky /= 2)  then
							hodina_jednotky  <= stiskla_klavesa;
					elsif (hodina_desitky = 2 and stiskla_klavesa < 4) then
							hodina_jednotky  <= stiskla_klavesa;
					end if;
				end if;
			end if;
			
			-- desitky minut
			if (kl_potvrd=4) then
				if kbrd_data_vld='1' and kbrd_data_out(15 downto 0)/="0000000000000000" and kbrd_data_out(12)='0' and kbrd_data_out(13)='0' then
					if stiskla_klavesa <= 5 then
							minuta_desitky  <= stiskla_klavesa;
					end if;
				end if;
			end if;
			
			-- minuty v radech jednotek
			if (kl_potvrd=3) then
				if kbrd_data_vld='1' and kbrd_data_out(15 downto 0)/="0000000000000000" and kbrd_data_out(12)='0' and kbrd_data_out(13)='0' then
					minuta_jednotky  <= stiskla_klavesa;
				end if;	
			end if;
			
			-- desitky sekund
			if (kl_potvrd=2) then
				if kbrd_data_vld='1' and kbrd_data_out(15 downto 0)/="0000000000000000" and kbrd_data_out(12)='0' and kbrd_data_out(13)='0' then
					if stiskla_klavesa <= 5 then
						sekunda_desitky  <= stiskla_klavesa;
					end if;
				end if;
			end if;
			
			-- par sekund
			if (kl_potvrd=1) then
				if kbrd_data_vld='1' and kbrd_data_out(15 downto 0)/="0000000000000000" and kbrd_data_out(12)='0' and kbrd_data_out(13)='0' then
						sekunda_jednotky <= stiskla_klavesa;
				end if;			
			end if;
			
		
			------citac pres povolovaci signal z klavesnice (A) a (B)
			if kbrd_data_vld='1' and kbrd_data_out(12)='1' and stiskla_klavesa=12  then
				if kl_potvrd/= 1 then
						kl_potvrd <= kl_potvrd - 1;
				end if;
			end if;
			if kbrd_data_vld='1' and kbrd_data_out(13)='1' and stiskla_klavesa=13 then
				if kl_potvrd/= 6 then
						kl_potvrd <= kl_potvrd + 1;
				end if;
			end if;
		
			------spusteni hodin
			if kbrd_data_vld='1' and kbrd_data_out(11)='1' then
				clock_ready <= '0';
				rst_clock <= '0';
			end if;
		end if;


		
	      --- HODINY ------------------------------------------------
			if (en_1Hz='1') and  (clock_ready = '0') then
			
					-- sekundy jednotky + desitky
					if (sekunda_jednotky = 9) then
						sekunda_jednotky <= 0;
				
						if sekunda_desitky /= 5 then
							sekunda_desitky <= sekunda_desitky + 1;
						else
							sekunda_desitky <= 0;
						end if;
				
					else
						sekunda_jednotky <= sekunda_jednotky + 1;
					end if;


			
					-- minuty jednotky + desitky
					if (sekunda_jednotky = 9) and (sekunda_desitky = 5) then
						if minuta_jednotky /= 9 then
							minuta_jednotky <= minuta_jednotky + 1;
						else
							if (minuta_jednotky=9) and (minuta_desitky=5) then
								hour:=1;
							end if;
							minuta_jednotky <= 0;
							if (minuta_desitky /= 5) then
								minuta_desitky <= minuta_desitky + 1;
							else
								minuta_desitky <= 0;
							end if;
						end if;
					end if;


					-- hodiny
					if hour=1 then
						hour := 0;
						if (hodina_jednotky /= 9) then
							if (hodina_desitky = 2) and (hodina_jednotky=3) then
								hodina_desitky  <= 0;
								hodina_jednotky <= 0;
							else
								hodina_jednotky <= hodina_jednotky + 1;
							end if;
						else
							hodina_jednotky <= 0;
							if (hodina_desitky /= 2) then
								hodina_desitky <=  hodina_desitky + 1;
							else
								hodina_desitky  <= 0;
								hodina_jednotky <= 0;
							end if;
					
						end if;
					end if;
				end if; --end 1hz
			 --- HODINY ------------------------------------------------
   end if; -- clk
end process;   








--- VYBER Z ROM PAMETI ----------------------------------------------

rom_col <= conv_integer(vgaCol(4 downto 1)) * 2;
rozdelovac_mx <= rom_rozdelovac(conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);

sekunda_mx_jedn <= rom_cislic(sekunda_jednotky*16 + conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);
sekunda_mx_des  <= rom_cislic(sekunda_desitky*16+conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);

minuta_mx_jedn <= rom_cislic(minuta_jednotky*16+conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);
minuta_mx_des  <= rom_cislic(minuta_desitky*16+conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);

hodina_mx_jedn <= rom_cislic(hodina_jednotky*16+conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);
hodina_mx_des  <= rom_cislic(hodina_desitky*16+conv_integer(vgaRow(5 downto 1)))(rom_col to rom_col+1);


-- INTERPRETACE BAREV----------------------------------------------

-- sekunda jednotky
sec_jedn <= "000"&"101"&"000" when sekunda_mx_jedn="01" else
       "000"&"101"&"000" when sekunda_mx_jedn="11"  and kl_potvrd=1 and clock_ready = '1' else
       "111"&"111"&"111" when sekunda_mx_jedn="11" else
       "000"&"000"&"000";

-- rozdelovac	 
rgba <= "000"&"101"&"000"  when rozdelovac_mx ="11" and clock_ready = '0' else
		  "101"&"000"&"000"  when rozdelovac_mx ="11" and clock_ready = '1' else
        "000"&"000"&"000";

-- sekunda desitky
sec_des <= "111"&"000"&"000"  when sekunda_mx_des="01" else
         "000"&"101"&"000"  when sekunda_mx_des="11" and kl_potvrd=2 and clock_ready = '1' else
         "111"&"111"&"111"  when sekunda_mx_des="11" else
         "000"&"000"&"000";
			
-- minuta jednotky	 
rgb_min_jedn <= "111"&"000"&"000"  when minuta_mx_jedn="01" else
         "000"&"101"&"000"  when minuta_mx_jedn="11" and kl_potvrd=3 and clock_ready = '1' else
         "111"&"111"&"111"  when minuta_mx_jedn="11" else
         "000"&"000"&"000";
			
-- minuta desitky	 
rgb_min_des <= "111"&"000"&"000"  when minuta_mx_des="01" else
         "000"&"101"&"000"  when minuta_mx_des="11" and kl_potvrd=4 and clock_ready = '1' else
         "111"&"111"&"111"  when minuta_mx_des="11" else
         "000"&"000"&"000";			

-- hodina jednotky 
rgb_hod_jedn <= "111"&"000"&"000"  when hodina_mx_jedn="01" else
					 "000"&"101"&"000"  when hodina_mx_jedn="11" and kl_potvrd=5 and clock_ready = '1' else -- and kl_potvrd=5
					 "111"&"111"&"111"  when hodina_mx_jedn="11" else
					 "000"&"000"&"000";			

-- hodina desitky
rgb_hod_des <= "111"&"000"&"000"  when hodina_mx_des="01" else
					"000"&"101"&"000"  when hodina_mx_des="11" and kl_potvrd=6 and clock_ready = '1' else --and kl_potvrd=6
					"111"&"111"&"111"  when hodina_mx_des="11" else
					"000"&"000"&"000";			


-- ZOBRAZENI na VGA --------------------------------------
rgbf <=	sec_jedn   when (vgaCol(11 downto 5) = "0001101") and (vgaRow(11 downto 5) = "0001000") else
			sec_des   when (vgaCol(11 downto 5) = "0001100") and (vgaRow(11 downto 5) = "0001000") else
			
			rgba   when (vgaCol(11 downto 5) = "0001011") and (vgaRow(11 downto 5) = "0001000") else
			
			rgb_min_jedn   when (vgaCol(11 downto 5) = "0001010") and (vgaRow(11 downto 5) = "0001000") else
			rgb_min_des   when (vgaCol(11 downto 5) = "0001001") and (vgaRow(11 downto 5) = "0001000") else
			
			rgba   when (vgaCol(11 downto 5) = "0001000") and (vgaRow(11 downto 5) = "0001000") else
			
			rgb_hod_jedn    when (vgaCol(11 downto 5) = "0000111") and (vgaRow(11 downto 5) = "0001000") else
			rgb_hod_des     when (vgaCol(11 downto 5) = "0000110") and (vgaRow(11 downto 5) = "0001000") else
			"000"&"000"&"000";
 
 
red <= rgbf(8 downto 6);
green <= rgbf(5 downto 3);
blue <= rgbf(2 downto 0);

end;