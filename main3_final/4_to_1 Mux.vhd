----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2020 13:49:03
-- Design Name: 
-- Module Name: four_to_one_multiplexer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY four_to_one_multiplexer is
    PORT (      
            A,B,C,D : in  STD_LOGIC_VECTOR (3 downto 0);
            X       : in  STD_LOGIC_VECTOR (1 downto 0);
            Z       : out STD_LOGIC_VECTOR (3 downto 0)
        );
END four_to_one_multiplexer;

ARCHITECTURE Behavioral of four_to_one_multiplexer is

begin 

    process (X ,A, B, C, D)
    
    begin
        -- Manually select input dependant on what value X is
        case X is
            when "00" => Z <= A;
            when "01" => Z <= B;
            when "10" => Z <= C;
            when "11" => Z <= D;
        end case;

    end process;
END Behavioral;

 
    end process;
END Behavioral;
