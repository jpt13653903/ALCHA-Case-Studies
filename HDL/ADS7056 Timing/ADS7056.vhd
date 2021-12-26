library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
--------------------------------------------------------------------------------

entity ADS7056 is port(
  ipClk   : in  std_logic;
  ipReset : in  std_logic;

  opnCS   : out std_logic;
  opSClk  : out std_logic;
  ipSDO   : in  std_logic;

  opData  : out std_logic_vector(13 downto 0);
  opValid : out std_logic
); end ADS7056;
--------------------------------------------------------------------------------

architecture Behaviour of ADS7056 is
  signal Reset : std_logic;

  signal Shift : std_logic_vector(13 downto 0);
  signal Count : unsigned        ( 5 downto 0);
--------------------------------------------------------------------------------

begin
  process(ipClk) begin
    if(rising_edge(ipClk)) then
      Reset <= ipReset;
      --------------------------------------------------------------------------

      if(Reset) then
        opnCS   <= '1';
        opSClk  <= '0';

        opData  <= (others => 'X');
        opValid <= '0';
        Shift   <= (others => 'X');
        Count   <= (others => '0');
      --------------------------------------------------------------------------

      else
        if(Count = 47) then Count <= (others => '0');
        else                Count <= Count + 1; end if;

        case(to_integer(Count)) is
          when 0       => opnCS  <= '0';
          when 1 to 36 => opSClk <= not(opSClk);
          when 37      => opnCS  <= '1';
          when others  => opSClk <= '0';
        end case;

        if(opSClk = '0') then
          Shift <= Shift(12 downto 0) & ipSDO;
        end if;

        if(Count = 32) then
          opData  <= Shift;
          opValid <= '1';
        else
          opValid <= '0';
        end if;
      end if;
    end if;
  end process;
end Behaviour;
--------------------------------------------------------------------------------

