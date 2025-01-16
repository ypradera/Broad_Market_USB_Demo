component lscc_spim1 is
    port(
        miso_i: in std_logic;
        sclk_o: out std_logic;
        mosi_o: out std_logic;
        ssn_o: out std_logic_vector(0 to 0);
        clk_i: in std_logic;
        rst_n_i: in std_logic;
        int_o: out std_logic;
        apb_penable_i: in std_logic;
        apb_psel_i: in std_logic;
        apb_pwrite_i: in std_logic;
        apb_paddr_i: in std_logic_vector(5 downto 0);
        apb_pwdata_i: in std_logic_vector(31 downto 0);
        apb_pready_o: out std_logic;
        apb_pslverr_o: out std_logic;
        apb_prdata_o: out std_logic_vector(31 downto 0)
    );
end component;

__: lscc_spim1 port map(
    miso_i=>,
    sclk_o=>,
    mosi_o=>,
    ssn_o=>,
    clk_i=>,
    rst_n_i=>,
    int_o=>,
    apb_penable_i=>,
    apb_psel_i=>,
    apb_pwrite_i=>,
    apb_paddr_i=>,
    apb_pwdata_i=>,
    apb_pready_o=>,
    apb_pslverr_o=>,
    apb_prdata_o=>
);
