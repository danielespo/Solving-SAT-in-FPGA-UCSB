-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
-- Date        : Wed Jul 10 17:25:07 2024
-- Host        : Barry-Home-PC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ validation_example_Module_Validation_Pl_0_0_sim_netlist.vhdl
-- Design      : validation_example_Module_Validation_Pl_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Platform_IO is
  port (
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wvalid_0 : out STD_LOGIC;
    \write_buffer_reg[2][7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \write_buffer_reg[3][7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \write_buffer_reg[0][7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \write_buffer_reg[1][7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    \write_buffer_reg[0][0]_0\ : in STD_LOGIC;
    \write_buffer_reg[0][0]_1\ : in STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    p_0_in_0 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    \axi_rdata_reg[0]\ : in STD_LOGIC;
    \axi_rdata_reg[0]_0\ : in STD_LOGIC;
    \axi_rdata_reg[0]_1\ : in STD_LOGIC;
    \axi_rdata_reg[6]\ : in STD_LOGIC;
    \axi_rdata_reg[19]\ : in STD_LOGIC;
    \axi_rdata_reg[11]\ : in STD_LOGIC;
    \axi_rdata_reg[12]\ : in STD_LOGIC;
    \axi_rdata_reg[17]\ : in STD_LOGIC;
    \axi_rdata_reg[27]\ : in STD_LOGIC;
    \axi_rdata_reg[20]\ : in STD_LOGIC;
    \axi_rdata_reg[21]\ : in STD_LOGIC;
    \axi_rdata_reg[22]\ : in STD_LOGIC;
    \axi_rdata_reg[23]\ : in STD_LOGIC;
    \axi_rdata_reg[1]\ : in STD_LOGIC;
    \axi_rdata_reg[2]\ : in STD_LOGIC;
    \axi_rdata_reg[3]\ : in STD_LOGIC;
    \axi_rdata_reg[4]\ : in STD_LOGIC;
    \axi_rdata_reg[5]\ : in STD_LOGIC;
    \axi_rdata_reg[7]\ : in STD_LOGIC;
    \axi_rdata_reg[8]\ : in STD_LOGIC;
    \axi_rdata_reg[9]\ : in STD_LOGIC;
    \axi_rdata_reg[10]\ : in STD_LOGIC;
    \axi_rdata_reg[13]\ : in STD_LOGIC;
    \axi_rdata_reg[14]\ : in STD_LOGIC;
    \axi_rdata_reg[15]\ : in STD_LOGIC;
    \axi_rdata_reg[16]\ : in STD_LOGIC;
    \axi_rdata_reg[18]\ : in STD_LOGIC;
    \axi_rdata_reg[24]\ : in STD_LOGIC;
    \axi_rdata_reg[25]\ : in STD_LOGIC;
    \axi_rdata_reg[26]\ : in STD_LOGIC;
    \axi_rdata_reg[28]\ : in STD_LOGIC;
    \axi_rdata_reg[29]\ : in STD_LOGIC;
    \axi_rdata_reg[30]\ : in STD_LOGIC;
    \axi_rdata_reg[31]\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    \write_buffer_reg[0][0]_2\ : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \axi_rdata_reg[0]_2\ : in STD_LOGIC;
    \axi_rdata_reg[1]_0\ : in STD_LOGIC;
    \axi_rdata_reg[2]_0\ : in STD_LOGIC;
    \axi_rdata_reg[4]_0\ : in STD_LOGIC;
    \axi_rdata_reg[5]_0\ : in STD_LOGIC;
    \axi_rdata_reg[6]_0\ : in STD_LOGIC;
    \axi_rdata_reg[7]_0\ : in STD_LOGIC;
    \axi_rdata_reg[8]_0\ : in STD_LOGIC;
    \axi_rdata_reg[9]_0\ : in STD_LOGIC;
    \axi_rdata_reg[10]_0\ : in STD_LOGIC;
    \axi_rdata_reg[11]_0\ : in STD_LOGIC;
    \axi_rdata_reg[12]_0\ : in STD_LOGIC;
    \axi_rdata_reg[13]_0\ : in STD_LOGIC;
    \axi_rdata_reg[14]_0\ : in STD_LOGIC;
    \axi_rdata_reg[15]_0\ : in STD_LOGIC;
    \axi_rdata_reg[16]_0\ : in STD_LOGIC;
    \axi_rdata_reg[17]_0\ : in STD_LOGIC;
    \axi_rdata_reg[18]_0\ : in STD_LOGIC;
    \axi_rdata_reg[19]_0\ : in STD_LOGIC;
    \axi_rdata_reg[20]_0\ : in STD_LOGIC;
    \axi_rdata_reg[21]_0\ : in STD_LOGIC;
    \axi_rdata_reg[22]_0\ : in STD_LOGIC;
    \axi_rdata_reg[23]_0\ : in STD_LOGIC;
    \axi_rdata_reg[24]_0\ : in STD_LOGIC;
    \axi_rdata_reg[25]_0\ : in STD_LOGIC;
    \axi_rdata_reg[26]_0\ : in STD_LOGIC;
    \axi_rdata_reg[27]_0\ : in STD_LOGIC;
    \axi_rdata_reg[28]_0\ : in STD_LOGIC;
    \axi_rdata_reg[29]_0\ : in STD_LOGIC;
    \axi_rdata_reg[30]_0\ : in STD_LOGIC;
    \axi_rdata_reg[31]_0\ : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    perph_i : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Platform_IO;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Platform_IO is
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \axi_rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[0]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[0]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[10]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[10]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[10]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[11]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[11]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[11]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[12]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[12]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[12]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[13]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[13]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[13]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[14]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[14]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[14]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[15]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[15]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[15]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[16]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[16]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[16]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[17]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[17]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[17]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[18]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[18]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[18]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[19]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[19]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[19]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[1]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[1]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[20]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[20]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[20]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[21]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[21]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[21]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[22]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[22]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[22]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[23]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[23]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[23]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[24]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[24]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[24]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[25]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[25]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[25]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[26]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[26]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[26]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[27]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[27]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[27]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[28]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[28]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[28]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[29]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[29]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[29]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[2]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[2]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[30]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[30]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[30]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[31]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[31]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[31]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[3]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[3]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[3]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[4]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[4]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[4]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[5]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[5]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[5]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[6]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[6]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[6]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[7]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[7]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[7]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[8]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[8]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[8]_i_5_n_0\ : STD_LOGIC;
  signal \axi_rdata[9]_i_2_n_0\ : STD_LOGIC;
  signal \axi_rdata[9]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[9]_i_5_n_0\ : STD_LOGIC;
  signal capture : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \read_buffer_reg[0]\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \read_buffer_reg[1]\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \read_buffer_reg[2]\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \read_buffer_reg[3]\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^s00_axi_wvalid_0\ : STD_LOGIC;
  signal write_buffer : STD_LOGIC;
  signal \write_buffer[0][7]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[0][7]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[0][7]_i_3_n_0\ : STD_LOGIC;
  signal \write_buffer[1][7]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[1][7]_i_3_n_0\ : STD_LOGIC;
  signal \write_buffer[1][7]_i_4_n_0\ : STD_LOGIC;
  signal \write_buffer[2][0]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][1]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][2]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][3]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][4]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][5]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][6]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][7]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[2][7]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[2][7]_i_3_n_0\ : STD_LOGIC;
  signal \write_buffer[3][0]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][0]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][1]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][1]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][2]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][2]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][3]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][3]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][4]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][4]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][5]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][5]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][6]_i_1_n_0\ : STD_LOGIC;
  signal \write_buffer[3][6]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_2_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_3_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_4_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_5_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_6_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_7_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_8_n_0\ : STD_LOGIC;
  signal \write_buffer[3][7]_i_9_n_0\ : STD_LOGIC;
  signal \^write_buffer_reg[0][7]_0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^write_buffer_reg[1][7]_0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^write_buffer_reg[2][7]_0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^write_buffer_reg[3][7]_0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of bram_we_a_INST_0_i_1 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \write_buffer[0][7]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \write_buffer[0][7]_i_3\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \write_buffer[1][3]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \write_buffer[1][4]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \write_buffer[1][5]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \write_buffer[1][6]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \write_buffer[1][7]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \write_buffer[1][7]_i_3\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \write_buffer[1][7]_i_4\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \write_buffer[2][7]_i_3\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \write_buffer[3][7]_i_3\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \write_buffer[3][7]_i_4\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \write_buffer[3][7]_i_5\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \write_buffer[3][7]_i_6\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \write_buffer[3][7]_i_8\ : label is "soft_lutpair4";
begin
  SR(0) <= \^sr\(0);
  s00_axi_wvalid_0 <= \^s00_axi_wvalid_0\;
  \write_buffer_reg[0][7]_0\(7 downto 0) <= \^write_buffer_reg[0][7]_0\(7 downto 0);
  \write_buffer_reg[1][7]_0\(7 downto 0) <= \^write_buffer_reg[1][7]_0\(7 downto 0);
  \write_buffer_reg[2][7]_0\(7 downto 0) <= \^write_buffer_reg[2][7]_0\(7 downto 0);
  \write_buffer_reg[3][7]_0\(7 downto 0) <= \^write_buffer_reg[3][7]_0\(7 downto 0);
\axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[0]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[0]_0\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[0]_i_4_n_0\,
      O => D(0)
    );
\axi_rdata[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(0),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[0]_i_5_n_0\,
      I5 => \axi_rdata_reg[0]_2\,
      O => \axi_rdata[0]_i_2_n_0\
    );
\axi_rdata[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \read_buffer_reg[2]\(0),
      I1 => \read_buffer_reg[3]\(0),
      I2 => \read_buffer_reg[0]\(0),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(0),
      O => \axi_rdata[0]_i_4_n_0\
    );
\axi_rdata[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(0),
      I1 => \^write_buffer_reg[3][7]_0\(0),
      I2 => \^write_buffer_reg[0][7]_0\(0),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(0),
      O => \axi_rdata[0]_i_5_n_0\
    );
\axi_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[10]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[10]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[10]_i_4_n_0\,
      O => D(10)
    );
\axi_rdata[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(10),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[10]_i_5_n_0\,
      I5 => \axi_rdata_reg[10]_0\,
      O => \axi_rdata[10]_i_2_n_0\
    );
\axi_rdata[10]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(2),
      I1 => \read_buffer_reg[3]\(2),
      I2 => \read_buffer_reg[0]\(2),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(2),
      O => \axi_rdata[10]_i_4_n_0\
    );
\axi_rdata[10]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(2),
      I1 => \^write_buffer_reg[3][7]_0\(2),
      I2 => \^write_buffer_reg[0][7]_0\(2),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(2),
      O => \axi_rdata[10]_i_5_n_0\
    );
\axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[11]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[11]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[11]_i_4_n_0\,
      O => D(11)
    );
\axi_rdata[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(11),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[11]_i_5_n_0\,
      I5 => \axi_rdata_reg[11]_0\,
      O => \axi_rdata[11]_i_2_n_0\
    );
\axi_rdata[11]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(3),
      I1 => \read_buffer_reg[3]\(3),
      I2 => \read_buffer_reg[0]\(3),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(3),
      O => \axi_rdata[11]_i_4_n_0\
    );
\axi_rdata[11]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(3),
      I1 => \^write_buffer_reg[3][7]_0\(3),
      I2 => \^write_buffer_reg[0][7]_0\(3),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(3),
      O => \axi_rdata[11]_i_5_n_0\
    );
\axi_rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[12]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[12]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[12]_i_4_n_0\,
      O => D(12)
    );
\axi_rdata[12]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(12),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[12]_i_5_n_0\,
      I5 => \axi_rdata_reg[12]_0\,
      O => \axi_rdata[12]_i_2_n_0\
    );
\axi_rdata[12]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F5533000F5533FF"
    )
        port map (
      I0 => \read_buffer_reg[3]\(4),
      I1 => \read_buffer_reg[2]\(4),
      I2 => \read_buffer_reg[0]\(4),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(4),
      O => \axi_rdata[12]_i_4_n_0\
    );
\axi_rdata[12]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(4),
      I1 => \^write_buffer_reg[3][7]_0\(4),
      I2 => \^write_buffer_reg[0][7]_0\(4),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(4),
      O => \axi_rdata[12]_i_5_n_0\
    );
\axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[13]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[13]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[13]_i_4_n_0\,
      O => D(13)
    );
\axi_rdata[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(13),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[13]_i_5_n_0\,
      I5 => \axi_rdata_reg[13]_0\,
      O => \axi_rdata[13]_i_2_n_0\
    );
\axi_rdata[13]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(5),
      I1 => \read_buffer_reg[3]\(5),
      I2 => \read_buffer_reg[0]\(5),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(5),
      O => \axi_rdata[13]_i_4_n_0\
    );
\axi_rdata[13]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(5),
      I1 => \^write_buffer_reg[3][7]_0\(5),
      I2 => \^write_buffer_reg[0][7]_0\(5),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(5),
      O => \axi_rdata[13]_i_5_n_0\
    );
\axi_rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[14]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[14]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[14]_i_4_n_0\,
      O => D(14)
    );
\axi_rdata[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(14),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[14]_i_5_n_0\,
      I5 => \axi_rdata_reg[14]_0\,
      O => \axi_rdata[14]_i_2_n_0\
    );
\axi_rdata[14]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(6),
      I1 => \read_buffer_reg[3]\(6),
      I2 => \read_buffer_reg[0]\(6),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(6),
      O => \axi_rdata[14]_i_4_n_0\
    );
\axi_rdata[14]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(6),
      I1 => \^write_buffer_reg[3][7]_0\(6),
      I2 => \^write_buffer_reg[0][7]_0\(6),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(6),
      O => \axi_rdata[14]_i_5_n_0\
    );
\axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[15]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[15]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[15]_i_4_n_0\,
      O => D(15)
    );
\axi_rdata[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(15),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[15]_i_5_n_0\,
      I5 => \axi_rdata_reg[15]_0\,
      O => \axi_rdata[15]_i_2_n_0\
    );
\axi_rdata[15]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(7),
      I1 => \read_buffer_reg[3]\(7),
      I2 => \read_buffer_reg[0]\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(7),
      O => \axi_rdata[15]_i_4_n_0\
    );
\axi_rdata[15]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(7),
      I1 => \^write_buffer_reg[3][7]_0\(7),
      I2 => \^write_buffer_reg[0][7]_0\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(7),
      O => \axi_rdata[15]_i_5_n_0\
    );
\axi_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[16]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[16]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[16]_i_4_n_0\,
      O => D(16)
    );
\axi_rdata[16]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(16),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[16]_i_5_n_0\,
      I5 => \axi_rdata_reg[16]_0\,
      O => \axi_rdata[16]_i_2_n_0\
    );
\axi_rdata[16]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => \read_buffer_reg[3]\(0),
      I1 => \read_buffer_reg[2]\(0),
      I2 => \read_buffer_reg[0]\(0),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(0),
      O => \axi_rdata[16]_i_4_n_0\
    );
\axi_rdata[16]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAAF0CC00AAF0CC"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(0),
      I1 => \^write_buffer_reg[2][7]_0\(0),
      I2 => \^write_buffer_reg[0][7]_0\(0),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(0),
      O => \axi_rdata[16]_i_5_n_0\
    );
\axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[17]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[17]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[17]_i_4_n_0\,
      O => D(17)
    );
\axi_rdata[17]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(17),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[17]_i_5_n_0\,
      I5 => \axi_rdata_reg[17]_0\,
      O => \axi_rdata[17]_i_2_n_0\
    );
\axi_rdata[17]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00330F55FF330F55"
    )
        port map (
      I0 => \read_buffer_reg[2]\(1),
      I1 => \read_buffer_reg[3]\(1),
      I2 => \read_buffer_reg[0]\(1),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(1),
      O => \axi_rdata[17]_i_4_n_0\
    );
\axi_rdata[17]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(1),
      I1 => \^write_buffer_reg[3][7]_0\(1),
      I2 => \^write_buffer_reg[0][7]_0\(1),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(1),
      O => \axi_rdata[17]_i_5_n_0\
    );
\axi_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[18]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[18]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[18]_i_4_n_0\,
      O => D(18)
    );
\axi_rdata[18]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(18),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[18]_i_5_n_0\,
      I5 => \axi_rdata_reg[18]_0\,
      O => \axi_rdata[18]_i_2_n_0\
    );
\axi_rdata[18]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => \read_buffer_reg[3]\(2),
      I1 => \read_buffer_reg[2]\(2),
      I2 => \read_buffer_reg[0]\(2),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(2),
      O => \axi_rdata[18]_i_4_n_0\
    );
\axi_rdata[18]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(2),
      I1 => \^write_buffer_reg[3][7]_0\(2),
      I2 => \^write_buffer_reg[0][7]_0\(2),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(2),
      O => \axi_rdata[18]_i_5_n_0\
    );
\axi_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[19]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[19]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[19]_i_4_n_0\,
      O => D(19)
    );
\axi_rdata[19]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(19),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[19]_i_5_n_0\,
      I5 => \axi_rdata_reg[19]_0\,
      O => \axi_rdata[19]_i_2_n_0\
    );
\axi_rdata[19]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00330F55FF330F55"
    )
        port map (
      I0 => \read_buffer_reg[2]\(3),
      I1 => \read_buffer_reg[3]\(3),
      I2 => \read_buffer_reg[0]\(3),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(3),
      O => \axi_rdata[19]_i_4_n_0\
    );
\axi_rdata[19]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(3),
      I1 => \^write_buffer_reg[3][7]_0\(3),
      I2 => \^write_buffer_reg[0][7]_0\(3),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(3),
      O => \axi_rdata[19]_i_5_n_0\
    );
\axi_rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[1]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[1]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[1]_i_4_n_0\,
      O => D(1)
    );
\axi_rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(1),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[1]_i_5_n_0\,
      I5 => \axi_rdata_reg[1]_0\,
      O => \axi_rdata[1]_i_2_n_0\
    );
\axi_rdata[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \read_buffer_reg[2]\(1),
      I1 => \read_buffer_reg[3]\(1),
      I2 => \read_buffer_reg[0]\(1),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(1),
      O => \axi_rdata[1]_i_4_n_0\
    );
\axi_rdata[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(1),
      I1 => \^write_buffer_reg[3][7]_0\(1),
      I2 => \^write_buffer_reg[0][7]_0\(1),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(1),
      O => \axi_rdata[1]_i_5_n_0\
    );
\axi_rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[20]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[20]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[20]_i_4_n_0\,
      O => D(20)
    );
\axi_rdata[20]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(20),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[20]_i_5_n_0\,
      I5 => \axi_rdata_reg[20]_0\,
      O => \axi_rdata[20]_i_2_n_0\
    );
\axi_rdata[20]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => \read_buffer_reg[3]\(4),
      I1 => \read_buffer_reg[2]\(4),
      I2 => \read_buffer_reg[0]\(4),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(4),
      O => \axi_rdata[20]_i_4_n_0\
    );
\axi_rdata[20]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(4),
      I1 => \^write_buffer_reg[3][7]_0\(4),
      I2 => \^write_buffer_reg[0][7]_0\(4),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(4),
      O => \axi_rdata[20]_i_5_n_0\
    );
\axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[21]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[21]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[21]_i_4_n_0\,
      O => D(21)
    );
\axi_rdata[21]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(21),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[21]_i_5_n_0\,
      I5 => \axi_rdata_reg[21]_0\,
      O => \axi_rdata[21]_i_2_n_0\
    );
\axi_rdata[21]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00330F55FF330F55"
    )
        port map (
      I0 => \read_buffer_reg[2]\(5),
      I1 => \read_buffer_reg[3]\(5),
      I2 => \read_buffer_reg[0]\(5),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(5),
      O => \axi_rdata[21]_i_4_n_0\
    );
\axi_rdata[21]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAAF0CC00AAF0CC"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(5),
      I1 => \^write_buffer_reg[2][7]_0\(5),
      I2 => \^write_buffer_reg[0][7]_0\(5),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(5),
      O => \axi_rdata[21]_i_5_n_0\
    );
\axi_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[22]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[22]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[22]_i_4_n_0\,
      O => D(22)
    );
\axi_rdata[22]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(22),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[22]_i_5_n_0\,
      I5 => \axi_rdata_reg[22]_0\,
      O => \axi_rdata[22]_i_2_n_0\
    );
\axi_rdata[22]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00330F55FF330F55"
    )
        port map (
      I0 => \read_buffer_reg[2]\(6),
      I1 => \read_buffer_reg[3]\(6),
      I2 => \read_buffer_reg[0]\(6),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[1]\(6),
      O => \axi_rdata[22]_i_4_n_0\
    );
\axi_rdata[22]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(6),
      I1 => \^write_buffer_reg[3][7]_0\(6),
      I2 => \^write_buffer_reg[0][7]_0\(6),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(6),
      O => \axi_rdata[22]_i_5_n_0\
    );
\axi_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[23]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[23]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[23]_i_4_n_0\,
      O => D(23)
    );
\axi_rdata[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(23),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[23]_i_5_n_0\,
      I5 => \axi_rdata_reg[23]_0\,
      O => \axi_rdata[23]_i_2_n_0\
    );
\axi_rdata[23]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => \read_buffer_reg[2]\(7),
      I1 => \read_buffer_reg[3]\(7),
      I2 => \read_buffer_reg[1]\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[0]\(7),
      O => \axi_rdata[23]_i_4_n_0\
    );
\axi_rdata[23]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(7),
      I1 => \^write_buffer_reg[3][7]_0\(7),
      I2 => \^write_buffer_reg[0][7]_0\(7),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \^write_buffer_reg[1][7]_0\(7),
      O => \axi_rdata[23]_i_5_n_0\
    );
\axi_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[24]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[24]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[24]_i_4_n_0\,
      O => D(24)
    );
\axi_rdata[24]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(24),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[24]_i_5_n_0\,
      I5 => \axi_rdata_reg[24]_0\,
      O => \axi_rdata[24]_i_2_n_0\
    );
\axi_rdata[24]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"33000F5533FF0F55"
    )
        port map (
      I0 => \read_buffer_reg[3]\(0),
      I1 => \read_buffer_reg[2]\(0),
      I2 => \read_buffer_reg[0]\(0),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(0),
      O => \axi_rdata[24]_i_4_n_0\
    );
\axi_rdata[24]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCFFF0AACC00F0AA"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(0),
      I1 => \^write_buffer_reg[2][7]_0\(0),
      I2 => \^write_buffer_reg[0][7]_0\(0),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(0),
      O => \axi_rdata[24]_i_5_n_0\
    );
\axi_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[25]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[25]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[25]_i_4_n_0\,
      O => D(25)
    );
\axi_rdata[25]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(25),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[25]_i_5_n_0\,
      I5 => \axi_rdata_reg[25]_0\,
      O => \axi_rdata[25]_i_2_n_0\
    );
\axi_rdata[25]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55000F3355FF0F33"
    )
        port map (
      I0 => \read_buffer_reg[2]\(1),
      I1 => \read_buffer_reg[3]\(1),
      I2 => \read_buffer_reg[0]\(1),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(1),
      O => \axi_rdata[25]_i_4_n_0\
    );
\axi_rdata[25]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFF0CCAA00F0CC"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(1),
      I1 => \^write_buffer_reg[3][7]_0\(1),
      I2 => \^write_buffer_reg[0][7]_0\(1),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(1),
      O => \axi_rdata[25]_i_5_n_0\
    );
\axi_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[26]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[26]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[26]_i_4_n_0\,
      O => D(26)
    );
\axi_rdata[26]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(26),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[26]_i_5_n_0\,
      I5 => \axi_rdata_reg[26]_0\,
      O => \axi_rdata[26]_i_2_n_0\
    );
\axi_rdata[26]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55000F3355FF0F33"
    )
        port map (
      I0 => \read_buffer_reg[2]\(2),
      I1 => \read_buffer_reg[3]\(2),
      I2 => \read_buffer_reg[1]\(2),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[0]\(2),
      O => \axi_rdata[26]_i_4_n_0\
    );
\axi_rdata[26]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFF0CCAA00F0CC"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(2),
      I1 => \^write_buffer_reg[3][7]_0\(2),
      I2 => \^write_buffer_reg[0][7]_0\(2),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(2),
      O => \axi_rdata[26]_i_5_n_0\
    );
\axi_rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[27]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[27]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[27]_i_4_n_0\,
      O => D(27)
    );
\axi_rdata[27]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(27),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[27]_i_5_n_0\,
      I5 => \axi_rdata_reg[27]_0\,
      O => \axi_rdata[27]_i_2_n_0\
    );
\axi_rdata[27]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"33000F5533FF0F55"
    )
        port map (
      I0 => \read_buffer_reg[3]\(3),
      I1 => \read_buffer_reg[2]\(3),
      I2 => \read_buffer_reg[0]\(3),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(3),
      O => \axi_rdata[27]_i_4_n_0\
    );
\axi_rdata[27]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFF0CCAA00F0CC"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(3),
      I1 => \^write_buffer_reg[3][7]_0\(3),
      I2 => \^write_buffer_reg[0][7]_0\(3),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(3),
      O => \axi_rdata[27]_i_5_n_0\
    );
\axi_rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[28]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[28]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[28]_i_4_n_0\,
      O => D(28)
    );
\axi_rdata[28]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(28),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[28]_i_5_n_0\,
      I5 => \axi_rdata_reg[28]_0\,
      O => \axi_rdata[28]_i_2_n_0\
    );
\axi_rdata[28]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55000F3355FF0F33"
    )
        port map (
      I0 => \read_buffer_reg[2]\(4),
      I1 => \read_buffer_reg[3]\(4),
      I2 => \read_buffer_reg[1]\(4),
      I3 => Q(1),
      I4 => Q(0),
      I5 => \read_buffer_reg[0]\(4),
      O => \axi_rdata[28]_i_4_n_0\
    );
\axi_rdata[28]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFF0CCAA00F0CC"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(4),
      I1 => \^write_buffer_reg[3][7]_0\(4),
      I2 => \^write_buffer_reg[0][7]_0\(4),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(4),
      O => \axi_rdata[28]_i_5_n_0\
    );
\axi_rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[29]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[29]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[29]_i_4_n_0\,
      O => D(29)
    );
\axi_rdata[29]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(29),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[29]_i_5_n_0\,
      I5 => \axi_rdata_reg[29]_0\,
      O => \axi_rdata[29]_i_2_n_0\
    );
\axi_rdata[29]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55000F3355FF0F33"
    )
        port map (
      I0 => \read_buffer_reg[2]\(5),
      I1 => \read_buffer_reg[3]\(5),
      I2 => \read_buffer_reg[0]\(5),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(5),
      O => \axi_rdata[29]_i_4_n_0\
    );
\axi_rdata[29]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCFFF0AACC00F0AA"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(5),
      I1 => \^write_buffer_reg[2][7]_0\(5),
      I2 => \^write_buffer_reg[0][7]_0\(5),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(5),
      O => \axi_rdata[29]_i_5_n_0\
    );
\axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[2]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[2]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[2]_i_4_n_0\,
      O => D(2)
    );
\axi_rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(2),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[2]_i_5_n_0\,
      I5 => \axi_rdata_reg[2]_0\,
      O => \axi_rdata[2]_i_2_n_0\
    );
\axi_rdata[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"33550F0033550FFF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(2),
      I1 => \read_buffer_reg[3]\(2),
      I2 => \read_buffer_reg[1]\(2),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[0]\(2),
      O => \axi_rdata[2]_i_4_n_0\
    );
\axi_rdata[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(2),
      I1 => \^write_buffer_reg[3][7]_0\(2),
      I2 => \^write_buffer_reg[0][7]_0\(2),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(2),
      O => \axi_rdata[2]_i_5_n_0\
    );
\axi_rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[30]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[30]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[30]_i_4_n_0\,
      O => D(30)
    );
\axi_rdata[30]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(30),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[30]_i_5_n_0\,
      I5 => \axi_rdata_reg[30]_0\,
      O => \axi_rdata[30]_i_2_n_0\
    );
\axi_rdata[30]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55000F3355FF0F33"
    )
        port map (
      I0 => \read_buffer_reg[2]\(6),
      I1 => \read_buffer_reg[3]\(6),
      I2 => \read_buffer_reg[0]\(6),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(6),
      O => \axi_rdata[30]_i_4_n_0\
    );
\axi_rdata[30]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFF0CCAA00F0CC"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(6),
      I1 => \^write_buffer_reg[3][7]_0\(6),
      I2 => \^write_buffer_reg[0][7]_0\(6),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(6),
      O => \axi_rdata[30]_i_5_n_0\
    );
\axi_rdata[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[31]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[31]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[31]_i_5_n_0\,
      O => D(31)
    );
\axi_rdata[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(31),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[31]_i_6_n_0\,
      I5 => \axi_rdata_reg[31]_0\,
      O => \axi_rdata[31]_i_2_n_0\
    );
\axi_rdata[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55000F3355FF0F33"
    )
        port map (
      I0 => \read_buffer_reg[2]\(7),
      I1 => \read_buffer_reg[3]\(7),
      I2 => \read_buffer_reg[0]\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(7),
      O => \axi_rdata[31]_i_5_n_0\
    );
\axi_rdata[31]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCFFF0AACC00F0AA"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(7),
      I1 => \^write_buffer_reg[2][7]_0\(7),
      I2 => \^write_buffer_reg[0][7]_0\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(7),
      O => \axi_rdata[31]_i_6_n_0\
    );
\axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[3]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[3]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[3]_i_4_n_0\,
      O => D(3)
    );
\axi_rdata[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF00AAF00000CCF0"
    )
        port map (
      I0 => bram_rddata_a(3),
      I1 => \axi_rdata[3]_i_5_n_0\,
      I2 => Q(2),
      I3 => axi_araddr(0),
      I4 => axi_araddr(1),
      I5 => \write_buffer_reg[0][0]_2\,
      O => \axi_rdata[3]_i_2_n_0\
    );
\axi_rdata[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5533000F5533FF0F"
    )
        port map (
      I0 => \read_buffer_reg[3]\(3),
      I1 => \read_buffer_reg[2]\(3),
      I2 => \read_buffer_reg[0]\(3),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(3),
      O => \axi_rdata[3]_i_4_n_0\
    );
\axi_rdata[3]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(3),
      I1 => \^write_buffer_reg[3][7]_0\(3),
      I2 => \^write_buffer_reg[0][7]_0\(3),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(3),
      O => \axi_rdata[3]_i_5_n_0\
    );
\axi_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[4]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[4]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[4]_i_4_n_0\,
      O => D(4)
    );
\axi_rdata[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(4),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[4]_i_5_n_0\,
      I5 => \axi_rdata_reg[4]_0\,
      O => \axi_rdata[4]_i_2_n_0\
    );
\axi_rdata[4]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5533000F5533FF0F"
    )
        port map (
      I0 => \read_buffer_reg[3]\(4),
      I1 => \read_buffer_reg[2]\(4),
      I2 => \read_buffer_reg[0]\(4),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(4),
      O => \axi_rdata[4]_i_4_n_0\
    );
\axi_rdata[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(4),
      I1 => \^write_buffer_reg[3][7]_0\(4),
      I2 => \^write_buffer_reg[0][7]_0\(4),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(4),
      O => \axi_rdata[4]_i_5_n_0\
    );
\axi_rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[5]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[5]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[5]_i_4_n_0\,
      O => D(5)
    );
\axi_rdata[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(5),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[5]_i_5_n_0\,
      I5 => \axi_rdata_reg[5]_0\,
      O => \axi_rdata[5]_i_2_n_0\
    );
\axi_rdata[5]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \read_buffer_reg[2]\(5),
      I1 => \read_buffer_reg[3]\(5),
      I2 => \read_buffer_reg[0]\(5),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(5),
      O => \axi_rdata[5]_i_4_n_0\
    );
\axi_rdata[5]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AACCFFF0AACC00F0"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(5),
      I1 => \^write_buffer_reg[2][7]_0\(5),
      I2 => \^write_buffer_reg[0][7]_0\(5),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(5),
      O => \axi_rdata[5]_i_5_n_0\
    );
\axi_rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[6]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[6]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[6]_i_4_n_0\,
      O => D(6)
    );
\axi_rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(6),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[6]_i_5_n_0\,
      I5 => \axi_rdata_reg[6]_0\,
      O => \axi_rdata[6]_i_2_n_0\
    );
\axi_rdata[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \read_buffer_reg[2]\(6),
      I1 => \read_buffer_reg[3]\(6),
      I2 => \read_buffer_reg[0]\(6),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(6),
      O => \axi_rdata[6]_i_4_n_0\
    );
\axi_rdata[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(6),
      I1 => \^write_buffer_reg[3][7]_0\(6),
      I2 => \^write_buffer_reg[0][7]_0\(6),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(6),
      O => \axi_rdata[6]_i_5_n_0\
    );
\axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[7]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[7]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[7]_i_4_n_0\,
      O => D(7)
    );
\axi_rdata[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(7),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[7]_i_5_n_0\,
      I5 => \axi_rdata_reg[7]_0\,
      O => \axi_rdata[7]_i_2_n_0\
    );
\axi_rdata[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"33550F0033550FFF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(7),
      I1 => \read_buffer_reg[3]\(7),
      I2 => \read_buffer_reg[1]\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[0]\(7),
      O => \axi_rdata[7]_i_4_n_0\
    );
\axi_rdata[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(7),
      I1 => \^write_buffer_reg[3][7]_0\(7),
      I2 => \^write_buffer_reg[0][7]_0\(7),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(7),
      O => \axi_rdata[7]_i_5_n_0\
    );
\axi_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[8]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[8]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[8]_i_4_n_0\,
      O => D(8)
    );
\axi_rdata[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(8),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[8]_i_5_n_0\,
      I5 => \axi_rdata_reg[8]_0\,
      O => \axi_rdata[8]_i_2_n_0\
    );
\axi_rdata[8]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(0),
      I1 => \read_buffer_reg[3]\(0),
      I2 => \read_buffer_reg[0]\(0),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(0),
      O => \axi_rdata[8]_i_4_n_0\
    );
\axi_rdata[8]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AACCFFF0AACC00"
    )
        port map (
      I0 => \^write_buffer_reg[3][7]_0\(0),
      I1 => \^write_buffer_reg[2][7]_0\(0),
      I2 => \^write_buffer_reg[0][7]_0\(0),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(0),
      O => \axi_rdata[8]_i_5_n_0\
    );
\axi_rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444545454445"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => \axi_rdata[9]_i_2_n_0\,
      I2 => \axi_rdata_reg[0]\,
      I3 => \axi_rdata_reg[9]\,
      I4 => \axi_rdata_reg[0]_1\,
      I5 => \axi_rdata[9]_i_4_n_0\,
      O => D(9)
    );
\axi_rdata[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF20222000"
    )
        port map (
      I0 => axi_araddr(0),
      I1 => axi_araddr(1),
      I2 => bram_rddata_a(9),
      I3 => \write_buffer_reg[0][0]_2\,
      I4 => \axi_rdata[9]_i_5_n_0\,
      I5 => \axi_rdata_reg[9]_0\,
      O => \axi_rdata[9]_i_2_n_0\
    );
\axi_rdata[9]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3355000F3355FF"
    )
        port map (
      I0 => \read_buffer_reg[2]\(1),
      I1 => \read_buffer_reg[3]\(1),
      I2 => \read_buffer_reg[0]\(1),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \read_buffer_reg[1]\(1),
      O => \axi_rdata[9]_i_4_n_0\
    );
\axi_rdata[9]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCAAFFF0CCAA00"
    )
        port map (
      I0 => \^write_buffer_reg[2][7]_0\(1),
      I1 => \^write_buffer_reg[3][7]_0\(1),
      I2 => \^write_buffer_reg[0][7]_0\(1),
      I3 => Q(0),
      I4 => Q(1),
      I5 => \^write_buffer_reg[1][7]_0\(1),
      O => \axi_rdata[9]_i_5_n_0\
    );
bram_rst_a_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s00_axi_aresetn,
      O => \^sr\(0)
    );
bram_we_a_INST_0_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => s00_axi_awvalid,
      I2 => \write_buffer_reg[0][0]_1\,
      I3 => \write_buffer_reg[0][0]_0\,
      O => \^s00_axi_wvalid_0\
    );
\read_buffer[0][7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000080"
    )
        port map (
      I0 => s00_axi_wdata(4),
      I1 => p_0_in_0(0),
      I2 => p_0_in_0(1),
      I3 => p_0_in_0(2),
      I4 => \^s00_axi_wvalid_0\,
      O => capture
    );
\read_buffer_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(0),
      Q => \read_buffer_reg[0]\(0),
      R => \^sr\(0)
    );
\read_buffer_reg[0][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(1),
      Q => \read_buffer_reg[0]\(1),
      R => \^sr\(0)
    );
\read_buffer_reg[0][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(2),
      Q => \read_buffer_reg[0]\(2),
      R => \^sr\(0)
    );
\read_buffer_reg[0][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(3),
      Q => \read_buffer_reg[0]\(3),
      R => \^sr\(0)
    );
\read_buffer_reg[0][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(4),
      Q => \read_buffer_reg[0]\(4),
      R => \^sr\(0)
    );
\read_buffer_reg[0][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(5),
      Q => \read_buffer_reg[0]\(5),
      R => \^sr\(0)
    );
\read_buffer_reg[0][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(6),
      Q => \read_buffer_reg[0]\(6),
      R => \^sr\(0)
    );
\read_buffer_reg[0][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(7),
      Q => \read_buffer_reg[0]\(7),
      R => \^sr\(0)
    );
\read_buffer_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(8),
      Q => \read_buffer_reg[1]\(0),
      R => \^sr\(0)
    );
\read_buffer_reg[1][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(9),
      Q => \read_buffer_reg[1]\(1),
      R => \^sr\(0)
    );
\read_buffer_reg[1][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(10),
      Q => \read_buffer_reg[1]\(2),
      R => \^sr\(0)
    );
\read_buffer_reg[1][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(11),
      Q => \read_buffer_reg[1]\(3),
      R => \^sr\(0)
    );
\read_buffer_reg[1][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(12),
      Q => \read_buffer_reg[1]\(4),
      R => \^sr\(0)
    );
\read_buffer_reg[1][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(13),
      Q => \read_buffer_reg[1]\(5),
      R => \^sr\(0)
    );
\read_buffer_reg[1][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(14),
      Q => \read_buffer_reg[1]\(6),
      R => \^sr\(0)
    );
\read_buffer_reg[1][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(15),
      Q => \read_buffer_reg[1]\(7),
      R => \^sr\(0)
    );
\read_buffer_reg[2][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(16),
      Q => \read_buffer_reg[2]\(0),
      R => \^sr\(0)
    );
\read_buffer_reg[2][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(17),
      Q => \read_buffer_reg[2]\(1),
      R => \^sr\(0)
    );
\read_buffer_reg[2][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(18),
      Q => \read_buffer_reg[2]\(2),
      R => \^sr\(0)
    );
\read_buffer_reg[2][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(19),
      Q => \read_buffer_reg[2]\(3),
      R => \^sr\(0)
    );
\read_buffer_reg[2][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(20),
      Q => \read_buffer_reg[2]\(4),
      R => \^sr\(0)
    );
\read_buffer_reg[2][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(21),
      Q => \read_buffer_reg[2]\(5),
      R => \^sr\(0)
    );
\read_buffer_reg[2][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(22),
      Q => \read_buffer_reg[2]\(6),
      R => \^sr\(0)
    );
\read_buffer_reg[2][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(23),
      Q => \read_buffer_reg[2]\(7),
      R => \^sr\(0)
    );
\read_buffer_reg[3][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(24),
      Q => \read_buffer_reg[3]\(0),
      R => \^sr\(0)
    );
\read_buffer_reg[3][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(25),
      Q => \read_buffer_reg[3]\(1),
      R => \^sr\(0)
    );
\read_buffer_reg[3][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(26),
      Q => \read_buffer_reg[3]\(2),
      R => \^sr\(0)
    );
\read_buffer_reg[3][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(27),
      Q => \read_buffer_reg[3]\(3),
      R => \^sr\(0)
    );
\read_buffer_reg[3][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(28),
      Q => \read_buffer_reg[3]\(4),
      R => \^sr\(0)
    );
\read_buffer_reg[3][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(29),
      Q => \read_buffer_reg[3]\(5),
      R => \^sr\(0)
    );
\read_buffer_reg[3][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(30),
      Q => \read_buffer_reg[3]\(6),
      R => \^sr\(0)
    );
\read_buffer_reg[3][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => capture,
      D => perph_i(31),
      Q => \read_buffer_reg[3]\(7),
      R => \^sr\(0)
    );
\write_buffer[0][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000004"
    )
        port map (
      I0 => \write_buffer[0][7]_i_2_n_0\,
      I1 => p_0_in_0(0),
      I2 => p_0_in_0(2),
      I3 => p_0_in_0(1),
      I4 => \write_buffer[0][7]_i_3_n_0\,
      I5 => \write_buffer_reg[0][0]_2\,
      O => \write_buffer[0][7]_i_1_n_0\
    );
\write_buffer[0][7]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(1),
      I1 => Q(0),
      O => \write_buffer[0][7]_i_2_n_0\
    );
\write_buffer[0][7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFFFFFF"
    )
        port map (
      I0 => \write_buffer_reg[0][0]_0\,
      I1 => \write_buffer_reg[0][0]_1\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_wvalid,
      I4 => s00_axi_wstrb(0),
      O => \write_buffer[0][7]_i_3_n_0\
    );
\write_buffer[1][0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(0),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(8),
      O => p_0_in(0)
    );
\write_buffer[1][1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(1),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(9),
      O => p_0_in(1)
    );
\write_buffer[1][2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(2),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(10),
      O => p_0_in(2)
    );
\write_buffer[1][3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(3),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(11),
      O => p_0_in(3)
    );
\write_buffer[1][4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(4),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(12),
      O => p_0_in(4)
    );
\write_buffer[1][5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(5),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(13),
      O => p_0_in(5)
    );
\write_buffer[1][6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(6),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(14),
      O => p_0_in(6)
    );
\write_buffer[1][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000010100000301"
    )
        port map (
      I0 => \write_buffer[1][7]_i_3_n_0\,
      I1 => \write_buffer_reg[0][0]_2\,
      I2 => \^s00_axi_wvalid_0\,
      I3 => s00_axi_wstrb(0),
      I4 => \write_buffer[1][7]_i_4_n_0\,
      I5 => \write_buffer[3][7]_i_8_n_0\,
      O => \write_buffer[1][7]_i_1_n_0\
    );
\write_buffer[1][7]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABAAA8AA"
    )
        port map (
      I0 => s00_axi_wdata(7),
      I1 => Q(0),
      I2 => Q(1),
      I3 => s00_axi_wstrb(1),
      I4 => s00_axi_wdata(15),
      O => p_0_in(7)
    );
\write_buffer[1][7]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EF"
    )
        port map (
      I0 => Q(0),
      I1 => Q(1),
      I2 => s00_axi_wstrb(1),
      O => \write_buffer[1][7]_i_3_n_0\
    );
\write_buffer[1][7]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EF"
    )
        port map (
      I0 => p_0_in_0(1),
      I1 => p_0_in_0(2),
      I2 => p_0_in_0(0),
      O => \write_buffer[1][7]_i_4_n_0\
    );
\write_buffer[2][0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000F2D0F2D0"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => \write_buffer[3][7]_i_8_n_0\,
      I2 => s00_axi_wdata(0),
      I3 => s00_axi_wdata(8),
      I4 => s00_axi_wdata(16),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][0]_i_1_n_0\
    );
\write_buffer[2][1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000F2D0F2D0"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => \write_buffer[3][7]_i_8_n_0\,
      I2 => s00_axi_wdata(1),
      I3 => s00_axi_wdata(9),
      I4 => s00_axi_wdata(17),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][1]_i_1_n_0\
    );
\write_buffer[2][2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000FB08FB08"
    )
        port map (
      I0 => s00_axi_wdata(10),
      I1 => s00_axi_wstrb(1),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => s00_axi_wdata(2),
      I4 => s00_axi_wdata(18),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][2]_i_1_n_0\
    );
\write_buffer[2][3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000FB08FB08"
    )
        port map (
      I0 => s00_axi_wdata(11),
      I1 => s00_axi_wstrb(1),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => s00_axi_wdata(3),
      I4 => s00_axi_wdata(19),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][3]_i_1_n_0\
    );
\write_buffer[2][4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000F2D0F2D0"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => \write_buffer[3][7]_i_8_n_0\,
      I2 => s00_axi_wdata(4),
      I3 => s00_axi_wdata(12),
      I4 => s00_axi_wdata(20),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][4]_i_1_n_0\
    );
\write_buffer[2][5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000F2D0F2D0"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => \write_buffer[3][7]_i_8_n_0\,
      I2 => s00_axi_wdata(5),
      I3 => s00_axi_wdata(13),
      I4 => s00_axi_wdata(21),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][5]_i_1_n_0\
    );
\write_buffer[2][6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000F2D0F2D0"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => \write_buffer[3][7]_i_8_n_0\,
      I2 => s00_axi_wdata(6),
      I3 => s00_axi_wdata(14),
      I4 => s00_axi_wdata(22),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][6]_i_1_n_0\
    );
\write_buffer[2][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0AA800A80A080008"
    )
        port map (
      I0 => \write_buffer[3][7]_i_3_n_0\,
      I1 => s00_axi_wstrb(2),
      I2 => Q(1),
      I3 => Q(0),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(0),
      O => \write_buffer[2][7]_i_1_n_0\
    );
\write_buffer[2][7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000F2D0F2D0"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => \write_buffer[3][7]_i_8_n_0\,
      I2 => s00_axi_wdata(7),
      I3 => s00_axi_wdata(15),
      I4 => s00_axi_wdata(23),
      I5 => \write_buffer[2][7]_i_3_n_0\,
      O => \write_buffer[2][7]_i_2_n_0\
    );
\write_buffer[2][7]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s00_axi_wstrb(2),
      I1 => Q(0),
      I2 => Q(1),
      O => \write_buffer[2][7]_i_3_n_0\
    );
\write_buffer[3][0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(16),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][0]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(24),
      O => \write_buffer[3][0]_i_1_n_0\
    );
\write_buffer[3][0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(0),
      I1 => s00_axi_wdata(8),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][0]_i_2_n_0\
    );
\write_buffer[3][1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(17),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][1]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(25),
      O => \write_buffer[3][1]_i_1_n_0\
    );
\write_buffer[3][1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(1),
      I1 => s00_axi_wdata(9),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][1]_i_2_n_0\
    );
\write_buffer[3][2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(18),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][2]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(26),
      O => \write_buffer[3][2]_i_1_n_0\
    );
\write_buffer[3][2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(2),
      I1 => s00_axi_wdata(10),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][2]_i_2_n_0\
    );
\write_buffer[3][3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(19),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][3]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(27),
      O => \write_buffer[3][3]_i_1_n_0\
    );
\write_buffer[3][3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CAFCCCFCCACCCCCC"
    )
        port map (
      I0 => s00_axi_wdata(11),
      I1 => s00_axi_wdata(3),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][3]_i_2_n_0\
    );
\write_buffer[3][4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(20),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][4]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(28),
      O => \write_buffer[3][4]_i_1_n_0\
    );
\write_buffer[3][4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(4),
      I1 => s00_axi_wdata(12),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][4]_i_2_n_0\
    );
\write_buffer[3][5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(21),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][5]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(29),
      O => \write_buffer[3][5]_i_1_n_0\
    );
\write_buffer[3][5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(5),
      I1 => s00_axi_wdata(13),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][5]_i_2_n_0\
    );
\write_buffer[3][6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(22),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][6]_i_2_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(30),
      O => \write_buffer[3][6]_i_1_n_0\
    );
\write_buffer[3][6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(6),
      I1 => s00_axi_wdata(14),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][6]_i_2_n_0\
    );
\write_buffer[3][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAA8A8AAA8"
    )
        port map (
      I0 => \write_buffer[3][7]_i_3_n_0\,
      I1 => \write_buffer[3][7]_i_4_n_0\,
      I2 => \write_buffer[3][7]_i_5_n_0\,
      I3 => s00_axi_wstrb(0),
      I4 => \write_buffer[3][7]_i_6_n_0\,
      I5 => \write_buffer[3][7]_i_7_n_0\,
      O => write_buffer
    );
\write_buffer[3][7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFB000000FB00"
    )
        port map (
      I0 => s00_axi_wdata(23),
      I1 => s00_axi_wstrb(2),
      I2 => \write_buffer[3][7]_i_8_n_0\,
      I3 => \write_buffer[3][7]_i_9_n_0\,
      I4 => \write_buffer[3][7]_i_7_n_0\,
      I5 => s00_axi_wdata(31),
      O => \write_buffer[3][7]_i_2_n_0\
    );
\write_buffer[3][7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000100"
    )
        port map (
      I0 => \^s00_axi_wvalid_0\,
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(2),
      I3 => p_0_in_0(0),
      I4 => \write_buffer_reg[0][0]_2\,
      O => \write_buffer[3][7]_i_3_n_0\
    );
\write_buffer[3][7]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s00_axi_wstrb(2),
      I1 => Q(0),
      I2 => Q(1),
      O => \write_buffer[3][7]_i_4_n_0\
    );
\write_buffer[3][7]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => Q(1),
      I2 => Q(0),
      O => \write_buffer[3][7]_i_5_n_0\
    );
\write_buffer[3][7]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => Q(1),
      I1 => Q(0),
      O => \write_buffer[3][7]_i_6_n_0\
    );
\write_buffer[3][7]_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s00_axi_wstrb(3),
      I1 => Q(0),
      I2 => Q(1),
      O => \write_buffer[3][7]_i_7_n_0\
    );
\write_buffer[3][7]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => Q(1),
      I1 => Q(0),
      O => \write_buffer[3][7]_i_8_n_0\
    );
\write_buffer[3][7]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ACFAAAFAACAAAAAA"
    )
        port map (
      I0 => s00_axi_wdata(7),
      I1 => s00_axi_wdata(15),
      I2 => Q(0),
      I3 => Q(1),
      I4 => s00_axi_wstrb(1),
      I5 => s00_axi_wstrb(2),
      O => \write_buffer[3][7]_i_9_n_0\
    );
\write_buffer_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => \^write_buffer_reg[0][7]_0\(0),
      R => \^sr\(0)
    );
\write_buffer_reg[0][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => \^write_buffer_reg[0][7]_0\(1),
      R => \^sr\(0)
    );
\write_buffer_reg[0][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => \^write_buffer_reg[0][7]_0\(2),
      R => \^sr\(0)
    );
\write_buffer_reg[0][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => \^write_buffer_reg[0][7]_0\(3),
      R => \^sr\(0)
    );
\write_buffer_reg[0][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => \^write_buffer_reg[0][7]_0\(4),
      R => \^sr\(0)
    );
\write_buffer_reg[0][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => \^write_buffer_reg[0][7]_0\(5),
      R => \^sr\(0)
    );
\write_buffer_reg[0][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => \^write_buffer_reg[0][7]_0\(6),
      R => \^sr\(0)
    );
\write_buffer_reg[0][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[0][7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => \^write_buffer_reg[0][7]_0\(7),
      R => \^sr\(0)
    );
\write_buffer_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(0),
      Q => \^write_buffer_reg[1][7]_0\(0),
      R => \^sr\(0)
    );
\write_buffer_reg[1][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(1),
      Q => \^write_buffer_reg[1][7]_0\(1),
      R => \^sr\(0)
    );
\write_buffer_reg[1][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(2),
      Q => \^write_buffer_reg[1][7]_0\(2),
      R => \^sr\(0)
    );
\write_buffer_reg[1][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(3),
      Q => \^write_buffer_reg[1][7]_0\(3),
      R => \^sr\(0)
    );
\write_buffer_reg[1][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(4),
      Q => \^write_buffer_reg[1][7]_0\(4),
      R => \^sr\(0)
    );
\write_buffer_reg[1][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(5),
      Q => \^write_buffer_reg[1][7]_0\(5),
      R => \^sr\(0)
    );
\write_buffer_reg[1][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(6),
      Q => \^write_buffer_reg[1][7]_0\(6),
      R => \^sr\(0)
    );
\write_buffer_reg[1][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[1][7]_i_1_n_0\,
      D => p_0_in(7),
      Q => \^write_buffer_reg[1][7]_0\(7),
      R => \^sr\(0)
    );
\write_buffer_reg[2][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][0]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(0),
      R => \^sr\(0)
    );
\write_buffer_reg[2][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][1]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(1),
      R => \^sr\(0)
    );
\write_buffer_reg[2][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][2]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(2),
      R => \^sr\(0)
    );
\write_buffer_reg[2][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][3]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(3),
      R => \^sr\(0)
    );
\write_buffer_reg[2][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][4]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(4),
      R => \^sr\(0)
    );
\write_buffer_reg[2][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][5]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(5),
      R => \^sr\(0)
    );
\write_buffer_reg[2][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][6]_i_1_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(6),
      R => \^sr\(0)
    );
\write_buffer_reg[2][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \write_buffer[2][7]_i_1_n_0\,
      D => \write_buffer[2][7]_i_2_n_0\,
      Q => \^write_buffer_reg[2][7]_0\(7),
      R => \^sr\(0)
    );
\write_buffer_reg[3][0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][0]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(0),
      R => \^sr\(0)
    );
\write_buffer_reg[3][1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][1]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(1),
      R => \^sr\(0)
    );
\write_buffer_reg[3][2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][2]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(2),
      R => \^sr\(0)
    );
\write_buffer_reg[3][3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][3]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(3),
      R => \^sr\(0)
    );
\write_buffer_reg[3][4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][4]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(4),
      R => \^sr\(0)
    );
\write_buffer_reg[3][5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][5]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(5),
      R => \^sr\(0)
    );
\write_buffer_reg[3][6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][6]_i_1_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(6),
      R => \^sr\(0)
    );
\write_buffer_reg[3][7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => write_buffer,
      D => \write_buffer[3][7]_i_2_n_0\,
      Q => \^write_buffer_reg[3][7]_0\(7),
      R => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0_S00_AXI is
  port (
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    s00_axi_aresetn_0 : out STD_LOGIC;
    bram_addr_a : out STD_LOGIC_VECTOR ( 11 downto 0 );
    perph_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_en_a : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_we_a : out STD_LOGIC;
    clk_o : out STD_LOGIC;
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    perph_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    bram_rddata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_bready : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0_S00_AXI;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0_S00_AXI is
  signal Platform_IO_inst_n_0 : STD_LOGIC;
  signal Platform_IO_inst_n_1 : STD_LOGIC;
  signal Platform_IO_inst_n_10 : STD_LOGIC;
  signal Platform_IO_inst_n_11 : STD_LOGIC;
  signal Platform_IO_inst_n_12 : STD_LOGIC;
  signal Platform_IO_inst_n_13 : STD_LOGIC;
  signal Platform_IO_inst_n_14 : STD_LOGIC;
  signal Platform_IO_inst_n_15 : STD_LOGIC;
  signal Platform_IO_inst_n_16 : STD_LOGIC;
  signal Platform_IO_inst_n_17 : STD_LOGIC;
  signal Platform_IO_inst_n_18 : STD_LOGIC;
  signal Platform_IO_inst_n_19 : STD_LOGIC;
  signal Platform_IO_inst_n_2 : STD_LOGIC;
  signal Platform_IO_inst_n_20 : STD_LOGIC;
  signal Platform_IO_inst_n_21 : STD_LOGIC;
  signal Platform_IO_inst_n_22 : STD_LOGIC;
  signal Platform_IO_inst_n_23 : STD_LOGIC;
  signal Platform_IO_inst_n_24 : STD_LOGIC;
  signal Platform_IO_inst_n_25 : STD_LOGIC;
  signal Platform_IO_inst_n_26 : STD_LOGIC;
  signal Platform_IO_inst_n_27 : STD_LOGIC;
  signal Platform_IO_inst_n_28 : STD_LOGIC;
  signal Platform_IO_inst_n_29 : STD_LOGIC;
  signal Platform_IO_inst_n_3 : STD_LOGIC;
  signal Platform_IO_inst_n_30 : STD_LOGIC;
  signal Platform_IO_inst_n_31 : STD_LOGIC;
  signal Platform_IO_inst_n_32 : STD_LOGIC;
  signal Platform_IO_inst_n_4 : STD_LOGIC;
  signal Platform_IO_inst_n_5 : STD_LOGIC;
  signal Platform_IO_inst_n_6 : STD_LOGIC;
  signal Platform_IO_inst_n_7 : STD_LOGIC;
  signal Platform_IO_inst_n_8 : STD_LOGIC;
  signal Platform_IO_inst_n_9 : STD_LOGIC;
  signal \^s_axi_arready\ : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal aw_en_i_1_n_0 : STD_LOGIC;
  signal aw_en_reg_n_0 : STD_LOGIC;
  signal axi_araddr : STD_LOGIC_VECTOR ( 4 downto 2 );
  signal \axi_araddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \axi_araddr[3]_i_1_n_0\ : STD_LOGIC;
  signal \axi_araddr[4]_i_1_n_0\ : STD_LOGIC;
  signal axi_arready0 : STD_LOGIC;
  signal \axi_awaddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \axi_awaddr[3]_i_1_n_0\ : STD_LOGIC;
  signal \axi_awaddr[4]_i_1_n_0\ : STD_LOGIC;
  signal axi_awready0 : STD_LOGIC;
  signal axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal \axi_rdata[0]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[0]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[10]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[10]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[11]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[11]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[12]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[12]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[13]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[13]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[14]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[14]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[15]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[15]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[16]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[16]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[17]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[17]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[18]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[18]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[19]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[19]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[1]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[20]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[20]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[21]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[21]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[22]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[22]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[23]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[23]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[24]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[24]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[25]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[25]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[26]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[26]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[27]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[27]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[28]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[28]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[29]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[29]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[2]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[2]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[30]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[30]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[31]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[31]_i_4_n_0\ : STD_LOGIC;
  signal \axi_rdata[31]_i_7_n_0\ : STD_LOGIC;
  signal \axi_rdata[3]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[4]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[4]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[5]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[5]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[6]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[6]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[7]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[7]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[8]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[8]_i_6_n_0\ : STD_LOGIC;
  signal \axi_rdata[9]_i_3_n_0\ : STD_LOGIC;
  signal \axi_rdata[9]_i_6_n_0\ : STD_LOGIC;
  signal axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal axi_wready0 : STD_LOGIC;
  signal \^bram_addr_a\ : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal \^bram_en_a\ : STD_LOGIC;
  signal p_0_in_0 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^s00_axi_aresetn_0\ : STD_LOGIC;
  signal \^s00_axi_bvalid\ : STD_LOGIC;
  signal \^s00_axi_rvalid\ : STD_LOGIC;
  signal slv_reg0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg0[13]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg3 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \slv_reg3[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[3]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[4]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[4]_i_2_n_0\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[10]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[11]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[12]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[13]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[14]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[15]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[16]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[17]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[18]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[19]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[20]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[21]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[22]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[23]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[24]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[25]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[26]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[27]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[28]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[29]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[2]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[30]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[31]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[4]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[5]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[6]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[7]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[8]\ : STD_LOGIC;
  signal \slv_reg3_reg_n_0_[9]\ : STD_LOGIC;
  signal \slv_reg_rden__0\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \axi_araddr[3]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \axi_araddr[4]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of axi_arready_i_1 : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of axi_awready_i_1 : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \axi_rdata[31]_i_3\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of axi_wready_i_1 : label is "soft_lutpair10";
begin
  S_AXI_ARREADY <= \^s_axi_arready\;
  S_AXI_AWREADY <= \^s_axi_awready\;
  S_AXI_WREADY <= \^s_axi_wready\;
  bram_addr_a(11 downto 0) <= \^bram_addr_a\(11 downto 0);
  bram_en_a <= \^bram_en_a\;
  s00_axi_aresetn_0 <= \^s00_axi_aresetn_0\;
  s00_axi_bvalid <= \^s00_axi_bvalid\;
  s00_axi_rvalid <= \^s00_axi_rvalid\;
Platform_IO_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Platform_IO
     port map (
      D(31) => Platform_IO_inst_n_0,
      D(30) => Platform_IO_inst_n_1,
      D(29) => Platform_IO_inst_n_2,
      D(28) => Platform_IO_inst_n_3,
      D(27) => Platform_IO_inst_n_4,
      D(26) => Platform_IO_inst_n_5,
      D(25) => Platform_IO_inst_n_6,
      D(24) => Platform_IO_inst_n_7,
      D(23) => Platform_IO_inst_n_8,
      D(22) => Platform_IO_inst_n_9,
      D(21) => Platform_IO_inst_n_10,
      D(20) => Platform_IO_inst_n_11,
      D(19) => Platform_IO_inst_n_12,
      D(18) => Platform_IO_inst_n_13,
      D(17) => Platform_IO_inst_n_14,
      D(16) => Platform_IO_inst_n_15,
      D(15) => Platform_IO_inst_n_16,
      D(14) => Platform_IO_inst_n_17,
      D(13) => Platform_IO_inst_n_18,
      D(12) => Platform_IO_inst_n_19,
      D(11) => Platform_IO_inst_n_20,
      D(10) => Platform_IO_inst_n_21,
      D(9) => Platform_IO_inst_n_22,
      D(8) => Platform_IO_inst_n_23,
      D(7) => Platform_IO_inst_n_24,
      D(6) => Platform_IO_inst_n_25,
      D(5) => Platform_IO_inst_n_26,
      D(4) => Platform_IO_inst_n_27,
      D(3) => Platform_IO_inst_n_28,
      D(2) => Platform_IO_inst_n_29,
      D(1) => Platform_IO_inst_n_30,
      D(0) => Platform_IO_inst_n_31,
      Q(2) => \^bram_addr_a\(1),
      Q(1 downto 0) => slv_reg0(1 downto 0),
      SR(0) => \^s00_axi_aresetn_0\,
      axi_araddr(2 downto 0) => axi_araddr(4 downto 2),
      \axi_rdata_reg[0]\ => \axi_rdata[31]_i_3_n_0\,
      \axi_rdata_reg[0]_0\ => \axi_rdata[0]_i_3_n_0\,
      \axi_rdata_reg[0]_1\ => \slv_reg3_reg_n_0_[2]\,
      \axi_rdata_reg[0]_2\ => \axi_rdata[0]_i_6_n_0\,
      \axi_rdata_reg[10]\ => \axi_rdata[10]_i_3_n_0\,
      \axi_rdata_reg[10]_0\ => \axi_rdata[10]_i_6_n_0\,
      \axi_rdata_reg[11]\ => \axi_rdata[11]_i_3_n_0\,
      \axi_rdata_reg[11]_0\ => \axi_rdata[11]_i_6_n_0\,
      \axi_rdata_reg[12]\ => \axi_rdata[12]_i_3_n_0\,
      \axi_rdata_reg[12]_0\ => \axi_rdata[12]_i_6_n_0\,
      \axi_rdata_reg[13]\ => \axi_rdata[13]_i_3_n_0\,
      \axi_rdata_reg[13]_0\ => \axi_rdata[13]_i_6_n_0\,
      \axi_rdata_reg[14]\ => \axi_rdata[14]_i_3_n_0\,
      \axi_rdata_reg[14]_0\ => \axi_rdata[14]_i_6_n_0\,
      \axi_rdata_reg[15]\ => \axi_rdata[15]_i_3_n_0\,
      \axi_rdata_reg[15]_0\ => \axi_rdata[15]_i_6_n_0\,
      \axi_rdata_reg[16]\ => \axi_rdata[16]_i_3_n_0\,
      \axi_rdata_reg[16]_0\ => \axi_rdata[16]_i_6_n_0\,
      \axi_rdata_reg[17]\ => \axi_rdata[17]_i_3_n_0\,
      \axi_rdata_reg[17]_0\ => \axi_rdata[17]_i_6_n_0\,
      \axi_rdata_reg[18]\ => \axi_rdata[18]_i_3_n_0\,
      \axi_rdata_reg[18]_0\ => \axi_rdata[18]_i_6_n_0\,
      \axi_rdata_reg[19]\ => \axi_rdata[19]_i_3_n_0\,
      \axi_rdata_reg[19]_0\ => \axi_rdata[19]_i_6_n_0\,
      \axi_rdata_reg[1]\ => \axi_rdata[1]_i_3_n_0\,
      \axi_rdata_reg[1]_0\ => \axi_rdata[1]_i_6_n_0\,
      \axi_rdata_reg[20]\ => \axi_rdata[20]_i_3_n_0\,
      \axi_rdata_reg[20]_0\ => \axi_rdata[20]_i_6_n_0\,
      \axi_rdata_reg[21]\ => \axi_rdata[21]_i_3_n_0\,
      \axi_rdata_reg[21]_0\ => \axi_rdata[21]_i_6_n_0\,
      \axi_rdata_reg[22]\ => \axi_rdata[22]_i_3_n_0\,
      \axi_rdata_reg[22]_0\ => \axi_rdata[22]_i_6_n_0\,
      \axi_rdata_reg[23]\ => \axi_rdata[23]_i_3_n_0\,
      \axi_rdata_reg[23]_0\ => \axi_rdata[23]_i_6_n_0\,
      \axi_rdata_reg[24]\ => \axi_rdata[24]_i_3_n_0\,
      \axi_rdata_reg[24]_0\ => \axi_rdata[24]_i_6_n_0\,
      \axi_rdata_reg[25]\ => \axi_rdata[25]_i_3_n_0\,
      \axi_rdata_reg[25]_0\ => \axi_rdata[25]_i_6_n_0\,
      \axi_rdata_reg[26]\ => \axi_rdata[26]_i_3_n_0\,
      \axi_rdata_reg[26]_0\ => \axi_rdata[26]_i_6_n_0\,
      \axi_rdata_reg[27]\ => \axi_rdata[27]_i_3_n_0\,
      \axi_rdata_reg[27]_0\ => \axi_rdata[27]_i_6_n_0\,
      \axi_rdata_reg[28]\ => \axi_rdata[28]_i_3_n_0\,
      \axi_rdata_reg[28]_0\ => \axi_rdata[28]_i_6_n_0\,
      \axi_rdata_reg[29]\ => \axi_rdata[29]_i_3_n_0\,
      \axi_rdata_reg[29]_0\ => \axi_rdata[29]_i_6_n_0\,
      \axi_rdata_reg[2]\ => \axi_rdata[2]_i_3_n_0\,
      \axi_rdata_reg[2]_0\ => \axi_rdata[2]_i_6_n_0\,
      \axi_rdata_reg[30]\ => \axi_rdata[30]_i_3_n_0\,
      \axi_rdata_reg[30]_0\ => \axi_rdata[30]_i_6_n_0\,
      \axi_rdata_reg[31]\ => \axi_rdata[31]_i_4_n_0\,
      \axi_rdata_reg[31]_0\ => \axi_rdata[31]_i_7_n_0\,
      \axi_rdata_reg[3]\ => \axi_rdata[3]_i_3_n_0\,
      \axi_rdata_reg[4]\ => \axi_rdata[4]_i_3_n_0\,
      \axi_rdata_reg[4]_0\ => \axi_rdata[4]_i_6_n_0\,
      \axi_rdata_reg[5]\ => \axi_rdata[5]_i_3_n_0\,
      \axi_rdata_reg[5]_0\ => \axi_rdata[5]_i_6_n_0\,
      \axi_rdata_reg[6]\ => \axi_rdata[6]_i_3_n_0\,
      \axi_rdata_reg[6]_0\ => \axi_rdata[6]_i_6_n_0\,
      \axi_rdata_reg[7]\ => \axi_rdata[7]_i_3_n_0\,
      \axi_rdata_reg[7]_0\ => \axi_rdata[7]_i_6_n_0\,
      \axi_rdata_reg[8]\ => \axi_rdata[8]_i_3_n_0\,
      \axi_rdata_reg[8]_0\ => \axi_rdata[8]_i_6_n_0\,
      \axi_rdata_reg[9]\ => \axi_rdata[9]_i_3_n_0\,
      \axi_rdata_reg[9]_0\ => \axi_rdata[9]_i_6_n_0\,
      bram_rddata_a(31 downto 0) => bram_rddata_a(31 downto 0),
      p_0_in_0(2 downto 0) => p_0_in_0(2 downto 0),
      perph_i(31 downto 0) => perph_i(31 downto 0),
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid,
      s00_axi_wvalid_0 => Platform_IO_inst_n_32,
      \write_buffer_reg[0][0]_0\ => \^s_axi_wready\,
      \write_buffer_reg[0][0]_1\ => \^s_axi_awready\,
      \write_buffer_reg[0][0]_2\ => \^bram_en_a\,
      \write_buffer_reg[0][7]_0\(7 downto 0) => perph_o(7 downto 0),
      \write_buffer_reg[1][7]_0\(7 downto 0) => perph_o(15 downto 8),
      \write_buffer_reg[2][7]_0\(7 downto 0) => perph_o(23 downto 16),
      \write_buffer_reg[3][7]_0\(7 downto 0) => perph_o(31 downto 24)
    );
aw_en_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF88880FFF8888"
    )
        port map (
      I0 => \^s00_axi_bvalid\,
      I1 => s00_axi_bready,
      I2 => s00_axi_wvalid,
      I3 => s00_axi_awvalid,
      I4 => aw_en_reg_n_0,
      I5 => \^s_axi_awready\,
      O => aw_en_i_1_n_0
    );
aw_en_reg: unisim.vcomponents.FDSE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => aw_en_i_1_n_0,
      Q => aw_en_reg_n_0,
      S => \^s00_axi_aresetn_0\
    );
\axi_araddr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(0),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(2),
      O => \axi_araddr[2]_i_1_n_0\
    );
\axi_araddr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(1),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(3),
      O => \axi_araddr[3]_i_1_n_0\
    );
\axi_araddr[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(2),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(4),
      O => \axi_araddr[4]_i_1_n_0\
    );
\axi_araddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_araddr[2]_i_1_n_0\,
      Q => axi_araddr(2),
      R => \^s00_axi_aresetn_0\
    );
\axi_araddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_araddr[3]_i_1_n_0\,
      Q => axi_araddr(3),
      R => \^s00_axi_aresetn_0\
    );
\axi_araddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_araddr[4]_i_1_n_0\,
      Q => axi_araddr(4),
      R => \^s00_axi_aresetn_0\
    );
axi_arready_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^s_axi_arready\,
      O => axi_arready0
    );
axi_arready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_arready0,
      Q => \^s_axi_arready\,
      R => \^s00_axi_aresetn_0\
    );
\axi_awaddr[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFFFFFFF20000000"
    )
        port map (
      I0 => s00_axi_awaddr(0),
      I1 => \^s_axi_awready\,
      I2 => aw_en_reg_n_0,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_wvalid,
      I5 => p_0_in_0(0),
      O => \axi_awaddr[2]_i_1_n_0\
    );
\axi_awaddr[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFFFFFFF20000000"
    )
        port map (
      I0 => s00_axi_awaddr(1),
      I1 => \^s_axi_awready\,
      I2 => aw_en_reg_n_0,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_wvalid,
      I5 => p_0_in_0(1),
      O => \axi_awaddr[3]_i_1_n_0\
    );
\axi_awaddr[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFFFFFFF20000000"
    )
        port map (
      I0 => s00_axi_awaddr(2),
      I1 => \^s_axi_awready\,
      I2 => aw_en_reg_n_0,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_wvalid,
      I5 => p_0_in_0(2),
      O => \axi_awaddr[4]_i_1_n_0\
    );
\axi_awaddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_awaddr[2]_i_1_n_0\,
      Q => p_0_in_0(0),
      R => \^s00_axi_aresetn_0\
    );
\axi_awaddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_awaddr[3]_i_1_n_0\,
      Q => p_0_in_0(1),
      R => \^s00_axi_aresetn_0\
    );
\axi_awaddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_awaddr[4]_i_1_n_0\,
      Q => p_0_in_0(2),
      R => \^s00_axi_aresetn_0\
    );
axi_awready_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => aw_en_reg_n_0,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_wvalid,
      O => axi_awready0
    );
axi_awready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_awready0,
      Q => \^s_axi_awready\,
      R => \^s00_axi_aresetn_0\
    );
axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55555555C0000000"
    )
        port map (
      I0 => s00_axi_bready,
      I1 => s00_axi_wvalid,
      I2 => s00_axi_awvalid,
      I3 => \^s_axi_awready\,
      I4 => \^s_axi_wready\,
      I5 => \^s00_axi_bvalid\,
      O => axi_bvalid_i_1_n_0
    );
axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_bvalid_i_1_n_0,
      Q => \^s00_axi_bvalid\,
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(0),
      I1 => perph_i(8),
      I2 => perph_i(24),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(16),
      O => \axi_rdata[0]_i_3_n_0\
    );
\axi_rdata[0]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => slv_reg3(0),
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(0),
      O => \axi_rdata[0]_i_6_n_0\
    );
\axi_rdata[10]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(18),
      I1 => perph_i(10),
      I2 => perph_i(26),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(2),
      O => \axi_rdata[10]_i_3_n_0\
    );
\axi_rdata[10]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[10]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(8),
      O => \axi_rdata[10]_i_6_n_0\
    );
\axi_rdata[11]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(11),
      I1 => perph_i(19),
      I2 => perph_i(3),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(27),
      O => \axi_rdata[11]_i_3_n_0\
    );
\axi_rdata[11]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[11]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(9),
      O => \axi_rdata[11]_i_6_n_0\
    );
\axi_rdata[12]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(12),
      I1 => perph_i(20),
      I2 => perph_i(4),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(28),
      O => \axi_rdata[12]_i_3_n_0\
    );
\axi_rdata[12]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[12]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(10),
      O => \axi_rdata[12]_i_6_n_0\
    );
\axi_rdata[13]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(21),
      I1 => perph_i(13),
      I2 => perph_i(29),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(5),
      O => \axi_rdata[13]_i_3_n_0\
    );
\axi_rdata[13]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[13]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(11),
      O => \axi_rdata[13]_i_6_n_0\
    );
\axi_rdata[14]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(22),
      I1 => perph_i(14),
      I2 => perph_i(30),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(6),
      O => \axi_rdata[14]_i_3_n_0\
    );
\axi_rdata[14]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[14]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(14),
      O => \axi_rdata[14]_i_6_n_0\
    );
\axi_rdata[15]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(23),
      I1 => perph_i(15),
      I2 => perph_i(31),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(7),
      O => \axi_rdata[15]_i_3_n_0\
    );
\axi_rdata[15]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[15]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(15),
      O => \axi_rdata[15]_i_6_n_0\
    );
\axi_rdata[16]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(24),
      I1 => perph_i(16),
      I2 => perph_i(8),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(0),
      O => \axi_rdata[16]_i_3_n_0\
    );
\axi_rdata[16]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[16]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(16),
      O => \axi_rdata[16]_i_6_n_0\
    );
\axi_rdata[17]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(17),
      I1 => perph_i(25),
      I2 => perph_i(9),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(1),
      O => \axi_rdata[17]_i_3_n_0\
    );
\axi_rdata[17]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[17]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(17),
      O => \axi_rdata[17]_i_6_n_0\
    );
\axi_rdata[18]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(26),
      I1 => perph_i(18),
      I2 => perph_i(10),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(2),
      O => \axi_rdata[18]_i_3_n_0\
    );
\axi_rdata[18]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[18]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(18),
      O => \axi_rdata[18]_i_6_n_0\
    );
\axi_rdata[19]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(27),
      I1 => perph_i(19),
      I2 => perph_i(3),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(11),
      O => \axi_rdata[19]_i_3_n_0\
    );
\axi_rdata[19]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[19]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(19),
      O => \axi_rdata[19]_i_6_n_0\
    );
\axi_rdata[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(9),
      I1 => perph_i(1),
      I2 => perph_i(25),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(17),
      O => \axi_rdata[1]_i_3_n_0\
    );
\axi_rdata[1]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => slv_reg3(1),
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(1),
      O => \axi_rdata[1]_i_6_n_0\
    );
\axi_rdata[20]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(20),
      I1 => perph_i(28),
      I2 => perph_i(12),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(4),
      O => \axi_rdata[20]_i_3_n_0\
    );
\axi_rdata[20]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[20]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(20),
      O => \axi_rdata[20]_i_6_n_0\
    );
\axi_rdata[21]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(29),
      I1 => perph_i(21),
      I2 => perph_i(5),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(13),
      O => \axi_rdata[21]_i_3_n_0\
    );
\axi_rdata[21]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[21]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(21),
      O => \axi_rdata[21]_i_6_n_0\
    );
\axi_rdata[22]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(22),
      I1 => perph_i(30),
      I2 => perph_i(14),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(6),
      O => \axi_rdata[22]_i_3_n_0\
    );
\axi_rdata[22]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[22]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(22),
      O => \axi_rdata[22]_i_6_n_0\
    );
\axi_rdata[23]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(31),
      I1 => perph_i(23),
      I2 => perph_i(15),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(7),
      O => \axi_rdata[23]_i_3_n_0\
    );
\axi_rdata[23]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[23]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(23),
      O => \axi_rdata[23]_i_6_n_0\
    );
\axi_rdata[24]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(0),
      I1 => perph_i(24),
      I2 => perph_i(8),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(16),
      O => \axi_rdata[24]_i_3_n_0\
    );
\axi_rdata[24]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[24]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(24),
      O => \axi_rdata[24]_i_6_n_0\
    );
\axi_rdata[25]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5533000F5533FF0F"
    )
        port map (
      I0 => perph_i(17),
      I1 => perph_i(9),
      I2 => perph_i(25),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(1),
      O => \axi_rdata[25]_i_3_n_0\
    );
\axi_rdata[25]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[25]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(25),
      O => \axi_rdata[25]_i_6_n_0\
    );
\axi_rdata[26]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(2),
      I1 => perph_i(26),
      I2 => perph_i(18),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(10),
      O => \axi_rdata[26]_i_3_n_0\
    );
\axi_rdata[26]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[26]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(26),
      O => \axi_rdata[26]_i_6_n_0\
    );
\axi_rdata[27]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(27),
      I1 => perph_i(3),
      I2 => perph_i(19),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(11),
      O => \axi_rdata[27]_i_3_n_0\
    );
\axi_rdata[27]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[27]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(27),
      O => \axi_rdata[27]_i_6_n_0\
    );
\axi_rdata[28]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(4),
      I1 => perph_i(28),
      I2 => perph_i(12),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(20),
      O => \axi_rdata[28]_i_3_n_0\
    );
\axi_rdata[28]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[28]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(28),
      O => \axi_rdata[28]_i_6_n_0\
    );
\axi_rdata[29]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(5),
      I1 => perph_i(29),
      I2 => perph_i(13),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(21),
      O => \axi_rdata[29]_i_3_n_0\
    );
\axi_rdata[29]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[29]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(29),
      O => \axi_rdata[29]_i_6_n_0\
    );
\axi_rdata[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(10),
      I1 => perph_i(2),
      I2 => perph_i(26),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(18),
      O => \axi_rdata[2]_i_3_n_0\
    );
\axi_rdata[2]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[2]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(0),
      O => \axi_rdata[2]_i_6_n_0\
    );
\axi_rdata[30]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(6),
      I1 => perph_i(30),
      I2 => perph_i(14),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(22),
      O => \axi_rdata[30]_i_3_n_0\
    );
\axi_rdata[30]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[30]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(30),
      O => \axi_rdata[30]_i_6_n_0\
    );
\axi_rdata[31]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => axi_araddr(2),
      I1 => axi_araddr(3),
      O => \axi_rdata[31]_i_3_n_0\
    );
\axi_rdata[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(7),
      I1 => perph_i(31),
      I2 => perph_i(15),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(23),
      O => \axi_rdata[31]_i_4_n_0\
    );
\axi_rdata[31]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[31]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => slv_reg0(31),
      O => \axi_rdata[31]_i_7_n_0\
    );
\axi_rdata[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(11),
      I1 => perph_i(3),
      I2 => perph_i(19),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(27),
      O => \axi_rdata[3]_i_3_n_0\
    );
\axi_rdata[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(12),
      I1 => perph_i(4),
      I2 => perph_i(20),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(28),
      O => \axi_rdata[4]_i_3_n_0\
    );
\axi_rdata[4]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[4]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(2),
      O => \axi_rdata[4]_i_6_n_0\
    );
\axi_rdata[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(13),
      I1 => perph_i(5),
      I2 => perph_i(29),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(21),
      O => \axi_rdata[5]_i_3_n_0\
    );
\axi_rdata[5]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[5]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(3),
      O => \axi_rdata[5]_i_6_n_0\
    );
\axi_rdata[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0033550FFF3355"
    )
        port map (
      I0 => perph_i(6),
      I1 => perph_i(14),
      I2 => perph_i(30),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(22),
      O => \axi_rdata[6]_i_3_n_0\
    );
\axi_rdata[6]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[6]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(4),
      O => \axi_rdata[6]_i_6_n_0\
    );
\axi_rdata[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F0055330FFF5533"
    )
        port map (
      I0 => perph_i(15),
      I1 => perph_i(7),
      I2 => perph_i(31),
      I3 => slv_reg0(0),
      I4 => slv_reg0(1),
      I5 => perph_i(23),
      O => \axi_rdata[7]_i_3_n_0\
    );
\axi_rdata[7]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[7]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(5),
      O => \axi_rdata[7]_i_6_n_0\
    );
\axi_rdata[8]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(16),
      I1 => perph_i(8),
      I2 => perph_i(24),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(0),
      O => \axi_rdata[8]_i_3_n_0\
    );
\axi_rdata[8]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[8]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(6),
      O => \axi_rdata[8]_i_6_n_0\
    );
\axi_rdata[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00550F33FF550F33"
    )
        port map (
      I0 => perph_i(17),
      I1 => perph_i(9),
      I2 => perph_i(25),
      I3 => slv_reg0(1),
      I4 => slv_reg0(0),
      I5 => perph_i(1),
      O => \axi_rdata[9]_i_3_n_0\
    );
\axi_rdata[9]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8380"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[9]\,
      I1 => axi_araddr(3),
      I2 => axi_araddr(2),
      I3 => \^bram_addr_a\(7),
      O => \axi_rdata[9]_i_6_n_0\
    );
\axi_rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_31,
      Q => s00_axi_rdata(0),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_21,
      Q => s00_axi_rdata(10),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_20,
      Q => s00_axi_rdata(11),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_19,
      Q => s00_axi_rdata(12),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_18,
      Q => s00_axi_rdata(13),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_17,
      Q => s00_axi_rdata(14),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_16,
      Q => s00_axi_rdata(15),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_15,
      Q => s00_axi_rdata(16),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_14,
      Q => s00_axi_rdata(17),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_13,
      Q => s00_axi_rdata(18),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_12,
      Q => s00_axi_rdata(19),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_30,
      Q => s00_axi_rdata(1),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_11,
      Q => s00_axi_rdata(20),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_10,
      Q => s00_axi_rdata(21),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_9,
      Q => s00_axi_rdata(22),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_8,
      Q => s00_axi_rdata(23),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_7,
      Q => s00_axi_rdata(24),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_6,
      Q => s00_axi_rdata(25),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_5,
      Q => s00_axi_rdata(26),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_4,
      Q => s00_axi_rdata(27),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_3,
      Q => s00_axi_rdata(28),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_2,
      Q => s00_axi_rdata(29),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_29,
      Q => s00_axi_rdata(2),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_1,
      Q => s00_axi_rdata(30),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_0,
      Q => s00_axi_rdata(31),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_28,
      Q => s00_axi_rdata(3),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_27,
      Q => s00_axi_rdata(4),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_26,
      Q => s00_axi_rdata(5),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_25,
      Q => s00_axi_rdata(6),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_24,
      Q => s00_axi_rdata(7),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_23,
      Q => s00_axi_rdata(8),
      R => \^s00_axi_aresetn_0\
    );
\axi_rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => Platform_IO_inst_n_22,
      Q => s00_axi_rdata(9),
      R => \^s00_axi_aresetn_0\
    );
axi_rvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08F8"
    )
        port map (
      I0 => \^s_axi_arready\,
      I1 => s00_axi_arvalid,
      I2 => \^s00_axi_rvalid\,
      I3 => s00_axi_rready,
      O => axi_rvalid_i_1_n_0
    );
axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_rvalid_i_1_n_0,
      Q => \^s00_axi_rvalid\,
      R => \^s00_axi_aresetn_0\
    );
axi_wready_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => aw_en_reg_n_0,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_wvalid,
      O => axi_wready0
    );
axi_wready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_wready0,
      Q => \^s_axi_wready\,
      R => \^s00_axi_aresetn_0\
    );
bram_clk_a_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => slv_reg3(1),
      I1 => slv_reg3(0),
      I2 => s00_axi_aclk,
      O => clk_o
    );
bram_we_a_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002000000000"
    )
        port map (
      I0 => \^bram_en_a\,
      I1 => Platform_IO_inst_n_32,
      I2 => s00_axi_wstrb(0),
      I3 => p_0_in_0(1),
      I4 => p_0_in_0(2),
      I5 => p_0_in_0(0),
      O => bram_we_a
    );
\slv_reg0[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000100"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => s00_axi_wstrb(1),
      I4 => Platform_IO_inst_n_32,
      O => \slv_reg0[13]_i_1_n_0\
    );
\slv_reg0[23]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000100"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => s00_axi_wstrb(2),
      I4 => Platform_IO_inst_n_32,
      O => \slv_reg0[23]_i_1_n_0\
    );
\slv_reg0[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000004"
    )
        port map (
      I0 => Platform_IO_inst_n_32,
      I1 => s00_axi_wstrb(3),
      I2 => p_0_in_0(2),
      I3 => p_0_in_0(1),
      I4 => p_0_in_0(0),
      O => \slv_reg0[31]_i_1_n_0\
    );
\slv_reg0[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000100"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => s00_axi_wstrb(0),
      I4 => Platform_IO_inst_n_32,
      O => \slv_reg0[7]_i_1_n_0\
    );
\slv_reg0_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg0(0),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => \^bram_addr_a\(8),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => \^bram_addr_a\(9),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => \^bram_addr_a\(10),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => \^bram_addr_a\(11),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg0(14),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg0(15),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg0(16),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg0(17),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg0(18),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg0(19),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg0(1),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg0(20),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg0(21),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg0(22),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg0(23),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg0(24),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg0(25),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg0(26),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg0(27),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg0(28),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg0(29),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => \^bram_addr_a\(0),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg0(30),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg0(31),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => \^bram_addr_a\(1),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => \^bram_addr_a\(2),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => \^bram_addr_a\(3),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => \^bram_addr_a\(4),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => \^bram_addr_a\(5),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => \^bram_addr_a\(6),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg0_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[13]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => \^bram_addr_a\(7),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004000"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => s00_axi_wstrb(1),
      I4 => Platform_IO_inst_n_32,
      O => \slv_reg3[15]_i_1_n_0\
    );
\slv_reg3[23]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004000"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => s00_axi_wstrb(2),
      I4 => Platform_IO_inst_n_32,
      O => \slv_reg3[23]_i_1_n_0\
    );
\slv_reg3[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00400000"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => Platform_IO_inst_n_32,
      I4 => s00_axi_wstrb(3),
      O => \slv_reg3[31]_i_1_n_0\
    );
\slv_reg3[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004000"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => p_0_in_0(1),
      I2 => p_0_in_0(0),
      I3 => s00_axi_wstrb(0),
      I4 => Platform_IO_inst_n_32,
      O => \slv_reg3[3]_i_1_n_0\
    );
\slv_reg3[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \slv_reg3[4]_i_2_n_0\,
      I1 => s00_axi_aresetn,
      I2 => \^s_axi_wready\,
      I3 => \^s_axi_awready\,
      I4 => s00_axi_awvalid,
      I5 => s00_axi_wvalid,
      O => \slv_reg3[4]_i_1_n_0\
    );
\slv_reg3[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888888888888888"
    )
        port map (
      I0 => \slv_reg3_reg_n_0_[4]\,
      I1 => p_0_in_0(2),
      I2 => p_0_in_0(0),
      I3 => p_0_in_0(1),
      I4 => s00_axi_wdata(4),
      I5 => s00_axi_wstrb(0),
      O => \slv_reg3[4]_i_2_n_0\
    );
\slv_reg3_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg3(0),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => \slv_reg3_reg_n_0_[10]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => \slv_reg3_reg_n_0_[11]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => \slv_reg3_reg_n_0_[12]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => \slv_reg3_reg_n_0_[13]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => \slv_reg3_reg_n_0_[14]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => \slv_reg3_reg_n_0_[15]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => \slv_reg3_reg_n_0_[16]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => \slv_reg3_reg_n_0_[17]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => \slv_reg3_reg_n_0_[18]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => \slv_reg3_reg_n_0_[19]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg3(1),
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => \slv_reg3_reg_n_0_[20]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => \slv_reg3_reg_n_0_[21]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => \slv_reg3_reg_n_0_[22]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => \slv_reg3_reg_n_0_[23]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => \slv_reg3_reg_n_0_[24]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => \slv_reg3_reg_n_0_[25]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => \slv_reg3_reg_n_0_[26]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => \slv_reg3_reg_n_0_[27]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => \slv_reg3_reg_n_0_[28]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => \slv_reg3_reg_n_0_[29]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => \slv_reg3_reg_n_0_[2]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => \slv_reg3_reg_n_0_[30]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => \slv_reg3_reg_n_0_[31]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => \^bram_en_a\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \slv_reg3[4]_i_1_n_0\,
      Q => \slv_reg3_reg_n_0_[4]\,
      R => '0'
    );
\slv_reg3_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => \slv_reg3_reg_n_0_[5]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => \slv_reg3_reg_n_0_[6]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[3]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => \slv_reg3_reg_n_0_[7]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => \slv_reg3_reg_n_0_[8]\,
      R => \^s00_axi_aresetn_0\
    );
\slv_reg3_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => \slv_reg3_reg_n_0_[9]\,
      R => \^s00_axi_aresetn_0\
    );
slv_reg_rden: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^s00_axi_rvalid\,
      I2 => \^s_axi_arready\,
      O => \slv_reg_rden__0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0 is
  port (
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 11 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \write_buffer_reg[1][7]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \write_buffer_reg[2][7]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \write_buffer_reg[3][7]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_en_a : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_we_a : out STD_LOGIC;
    clk_o : out STD_LOGIC;
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    perph_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    bram_rddata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_bready : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0 is
begin
Module_Validation_Platform_v1_0_S00_AXI_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0_S00_AXI
     port map (
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WREADY => S_AXI_WREADY,
      bram_addr_a(11 downto 0) => bram_addr_a(11 downto 0),
      bram_en_a => bram_en_a,
      bram_rddata_a(31 downto 0) => bram_rddata_a(31 downto 0),
      bram_we_a => bram_we_a,
      clk_o => clk_o,
      perph_i(31 downto 0) => perph_i(31 downto 0),
      perph_o(31 downto 24) => \write_buffer_reg[3][7]\(7 downto 0),
      perph_o(23 downto 16) => \write_buffer_reg[2][7]\(7 downto 0),
      perph_o(15 downto 8) => \write_buffer_reg[1][7]\(7 downto 0),
      perph_o(7 downto 0) => Q(7 downto 0),
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_araddr(2 downto 0) => s00_axi_araddr(2 downto 0),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_aresetn_0 => SR(0),
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(2 downto 0) => s00_axi_awaddr(2 downto 0),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    clk_o : out STD_LOGIC;
    perph_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    perph_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 11 downto 0 );
    bram_clk_a : out STD_LOGIC;
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_en_a : out STD_LOGIC;
    bram_rst_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "validation_example_Module_Validation_Pl_0_0,Module_Validation_Platform_v1_0,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "Module_Validation_Platform_v1_0,Vivado 2024.1";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \<const0>\ : STD_LOGIC;
  signal \^clk_o\ : STD_LOGIC;
  signal \^s00_axi_wdata\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of bram_clk_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK";
  attribute X_INTERFACE_INFO of bram_en_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA EN";
  attribute X_INTERFACE_INFO of bram_rst_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA RST";
  attribute X_INTERFACE_INFO of bram_we_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA WE";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of bram_we_a : signal is "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1";
  attribute X_INTERFACE_INFO of s00_axi_aclk : signal is "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK";
  attribute X_INTERFACE_PARAMETER of s00_axi_aclk : signal is "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN validation_example_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 S00_AXI_RST RST";
  attribute X_INTERFACE_PARAMETER of s00_axi_aresetn : signal is "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY";
  attribute X_INTERFACE_INFO of s00_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID";
  attribute X_INTERFACE_INFO of s00_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY";
  attribute X_INTERFACE_INFO of s00_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID";
  attribute X_INTERFACE_INFO of s00_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BREADY";
  attribute X_INTERFACE_INFO of s00_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BVALID";
  attribute X_INTERFACE_INFO of s00_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RREADY";
  attribute X_INTERFACE_PARAMETER of s00_axi_rready : signal is "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 8, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN validation_example_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RVALID";
  attribute X_INTERFACE_INFO of s00_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WREADY";
  attribute X_INTERFACE_INFO of s00_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WVALID";
  attribute X_INTERFACE_INFO of bram_addr_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR";
  attribute X_INTERFACE_INFO of bram_rddata_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT";
  attribute X_INTERFACE_INFO of bram_wrdata_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN";
  attribute X_INTERFACE_INFO of s00_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR";
  attribute X_INTERFACE_INFO of s00_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT";
  attribute X_INTERFACE_INFO of s00_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  attribute X_INTERFACE_INFO of s00_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT";
  attribute X_INTERFACE_INFO of s00_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BRESP";
  attribute X_INTERFACE_INFO of s00_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RDATA";
  attribute X_INTERFACE_INFO of s00_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RRESP";
  attribute X_INTERFACE_INFO of s00_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WDATA";
  attribute X_INTERFACE_INFO of s00_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB";
begin
  \^s00_axi_wdata\(31 downto 0) <= s00_axi_wdata(31 downto 0);
  bram_clk_a <= \^clk_o\;
  bram_wrdata_a(31 downto 0) <= \^s00_axi_wdata\(31 downto 0);
  clk_o <= \^clk_o\;
  s00_axi_bresp(1) <= \<const0>\;
  s00_axi_bresp(0) <= \<const0>\;
  s00_axi_rresp(1) <= \<const0>\;
  s00_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0
     port map (
      Q(7 downto 0) => perph_o(7 downto 0),
      SR(0) => bram_rst_a,
      S_AXI_ARREADY => s00_axi_arready,
      S_AXI_AWREADY => s00_axi_awready,
      S_AXI_WREADY => s00_axi_wready,
      bram_addr_a(11 downto 0) => bram_addr_a(11 downto 0),
      bram_en_a => bram_en_a,
      bram_rddata_a(31 downto 0) => bram_rddata_a(31 downto 0),
      bram_we_a => bram_we_a,
      clk_o => \^clk_o\,
      perph_i(31 downto 0) => perph_i(31 downto 0),
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_araddr(2 downto 0) => s00_axi_araddr(4 downto 2),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(2 downto 0) => s00_axi_awaddr(4 downto 2),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_wdata(31 downto 0) => \^s00_axi_wdata\(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid,
      \write_buffer_reg[1][7]\(7 downto 0) => perph_o(15 downto 8),
      \write_buffer_reg[2][7]\(7 downto 0) => perph_o(23 downto 16),
      \write_buffer_reg[3][7]\(7 downto 0) => perph_o(31 downto 24)
    );
end STRUCTURE;
