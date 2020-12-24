// SPDX-License-Identifier: MIT
import "./SafeMath.sol";
pragma solidity 0.6.10;
contract Analysis {
    using SafeMath for uint;
    uint MAX_UINT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    uint MAX_UINT_LESS_1 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe;
    uint MIN_UINT = 0x0000000000000000000000000000000000000000000000000000000000000000;
    uint MIN_UINT_PLUS_1 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    uint FIRST_PRIME_NUMBER_NOT_PAIR = 3;
    uint EULERO_PRIME_NUMBER = 2147483647;
    uint u0;
    uint u1;
    uint u2;
    int g1;
    int g2;
    uint n;
    int d;  //If > 0, s1 is more fast than s2, else s2 is more fast than s1
    string s0;
    string s1;
    string s2;
    mapping(string => int) data_d;
    event GasAnalyzeLog(string s0, string s1, string s2, uint u0, uint u1, uint u2, int g1, int g2, int d);
    modifier analyzeGas {
        _;
        (g1, g2, d) = (int(u0 - u1),int(u1 - u2),int(u0 + u2 - 2 * u1));
        emit GasAnalyzeLog(s0, s1, s2, u0, u1, u2, g1, g2, d);
    }
    function run_0001() public {
        gasAnalyze_0001(MIN_UINT);
        gasAnalyze_0001(MIN_UINT_PLUS_1);
        gasAnalyze_0001(FIRST_PRIME_NUMBER_NOT_PAIR);
        gasAnalyze_0001(EULERO_PRIME_NUMBER);
        gasAnalyze_0001(MAX_UINT_LESS_1);
        gasAnalyze_0001(MAX_UINT);
    }

        function run_0002() public {
        gasAnalyze_0002(MIN_UINT);
        gasAnalyze_0002(MIN_UINT_PLUS_1);
        gasAnalyze_0002(FIRST_PRIME_NUMBER_NOT_PAIR);
        gasAnalyze_0002(EULERO_PRIME_NUMBER);
        gasAnalyze_0002(MAX_UINT_LESS_1);
        gasAnalyze_0002(MAX_UINT);
    }

    function gasAnalyze_0001(uint _v) internal analyzeGas {
        uint r;
        (s0, s1, s2) = ("gasAnalyze_0001", "_v1 / 2", "_v1.div(2)");
        u0 = gasleft();
        r = _v / 2;
        u1 = gasleft();
        r = _v.div(2);
        u2 = gasleft();
    }

    function gasAnalyze_0002(uint _v) internal analyzeGas {
        uint r;
        (s0, s1, s2) = ("gasAnalyze_0002", "_v1 % 2", "_v1.mod(2)");
        u0 = gasleft();
        r = _v % 2;
        u1 = gasleft();
        r = _v.mod(2);
        u2 = gasleft();
    }
}
/*
    GAS ANALYZE 0001

	[ { "from": "0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0001", "1": "_v1 / 2", "2": "_v1.div(2)", "3": "2914141", "4": "2894095", "5": "2873836", "6": "20046", "7": "20259", "8": "-213", "s0": "gasAnalyze_0001", "s1": "_v1 / 2", "s2": "_v1.div(2)", "u0": "2914141", "u1": "2894095", "u2": "2873836", "g1": "20046", "g2": "20259", "d": "-213" } },
      { "from": "0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0001", "1": "_v1 / 2", "2": "_v1.div(2)", "3": "2761197", "4": "2760351", "5": "2759298", "6": "846", "7": "1053", "8": "-207", "s0": "gasAnalyze_0001", "s1": "_v1 / 2", "s2": "_v1.div(2)", "u0": "2761197", "u1": "2760351", "u2": "2759298", "g1": "846", "g2": "1053", "d": "-207" } },
      { "from": "0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0001", "1": "_v1 / 2", "2": "_v1.div(2)", "3": "2723480", "4": "2722634", "5": "2721581", "6": "846", "7": "1053", "8": "-207", "s0": "gasAnalyze_0001", "s1": "_v1 / 2", "s2": "_v1.div(2)", "u0": "2723480", "u1": "2722634", "u2": "2721581", "g1": "846", "g2": "1053", "d": "-207" } }, 
      { "from": "0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0001", "1": "_v1 / 2", "2": "_v1.div(2)", "3": "2685763", "4": "2684917", "5": "2683864", "6": "846", "7": "1053", "8": "-207", "s0": "gasAnalyze_0001", "s1": "_v1 / 2", "s2": "_v1.div(2)", "u0": "2685763", "u1": "2684917", "u2": "2683864", "g1": "846", "g2": "1053", "d": "-207" } }, 
      { "from": "0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0001", "1": "_v1 / 2", "2": "_v1.div(2)", "3": "2648045", "4": "2647199", "5": "2646146", "6": "846", "7": "1053", "8": "-207", "s0": "gasAnalyze_0001", "s1": "_v1 / 2", "s2": "_v1.div(2)", "u0": "2648045", "u1": "2647199", "u2": "2646146", "g1": "846", "g2": "1053", "d": "-207" } },
      { "from": "0x1d142a62E2e98474093545D4A3A0f7DB9503B8BD", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0001", "1": "_v1 / 2", "2": "_v1.div(2)", "3": "2610328", "4": "2609482", "5": "2608429", "6": "846", "7": "1053", "8": "-207", "s0": "gasAnalyze_0001", "s1": "_v1 / 2", "s2": "_v1.div(2)", "u0": "2610328", "u1": "2609482", "u2": "2608429", "g1": "846", "g2": "1053", "d": "-207" } } ]  

    GAS ANALYZE 0002

    [ { "from": "0x26b989b9525Bb775C8DEDf70FeE40C36B397CE67", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0002", "1": "_v1 % 2", "2": "_v1.mod(2)", "3": "2914141", "4": "2894095", "5": "2873846", "6": "20046", "7": "20249", "8": "-203", "s0": "gasAnalyze_0002", "s1": "_v1 % 2", "s2": "_v1.mod(2)", "u0": "2914141", "u1": "2894095", "u2": "2873846", "g1": "20046", "g2": "20249", "d": "-203" } }, 
      { "from": "0x26b989b9525Bb775C8DEDf70FeE40C36B397CE67", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0002", "1": "_v1 % 2", "2": "_v1.mod(2)", "3": "2761207", "4": "2760361", "5": "2759318", "6": "846", "7": "1043", "8": "-197", "s0": "gasAnalyze_0002", "s1": "_v1 % 2", "s2": "_v1.mod(2)", "u0": "2761207", "u1": "2760361", "u2": "2759318", "g1": "846", "g2": "1043", "d": "-197" } }, 
      { "from": "0x26b989b9525Bb775C8DEDf70FeE40C36B397CE67", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0002", "1": "_v1 % 2", "2": "_v1.mod(2)", "3": "2723500", "4": "2722654", "5": "2721611", "6": "846", "7": "1043", "8": "-197", "s0": "gasAnalyze_0002", "s1": "_v1 % 2", "s2": "_v1.mod(2)", "u0": "2723500", "u1": "2722654", "u2": "2721611", "g1": "846", "g2": "1043", "d": "-197" } }, 
      { "from": "0x26b989b9525Bb775C8DEDf70FeE40C36B397CE67", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0002", "1": "_v1 % 2", "2": "_v1.mod(2)", "3": "2685793", "4": "2684947", "5": "2683904", "6": "846", "7": "1043", "8": "-197", "s0": "gasAnalyze_0002", "s1": "_v1 % 2", "s2": "_v1.mod(2)", "u0": "2685793", "u1": "2684947", "u2": "2683904", "g1": "846", "g2": "1043", "d": "-197" } }, 
      { "from": "0x26b989b9525Bb775C8DEDf70FeE40C36B397CE67", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0002", "1": "_v1 % 2", "2": "_v1.mod(2)", "3": "2648085", "4": "2647239", "5": "2646196", "6": "846", "7": "1043", "8": "-197", "s0": "gasAnalyze_0002", "s1": "_v1 % 2", "s2": "_v1.mod(2)", "u0": "2648085", "u1": "2647239", "u2": "2646196", "g1": "846", "g2": "1043", "d": "-197" } }, 
      { "from": "0x26b989b9525Bb775C8DEDf70FeE40C36B397CE67", "topic": "0x9459632d879619ddc2e0553cd90d2c0250e29952a06e1649f519e0d7d9ae0a47", "event": "GasAnalyzeLog", "args": { "0": "gasAnalyze_0002", "1": "_v1 % 2", "2": "_v1.mod(2)", "3": "2610378", "4": "2609532", "5": "2608489", "6": "846", "7": "1043", "8": "-197", "s0": "gasAnalyze_0002", "s1": "_v1 % 2", "s2": "_v1.mod(2)", "u0": "2610378", "u1": "2609532", "u2": "2608489", "g1": "846", "g2": "1043", "d": "-197" } } ]  
*/