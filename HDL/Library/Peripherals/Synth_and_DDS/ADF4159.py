class ADF4159:
    def __init__(self):
        # Tuning parameters
        self.CP_CurrentSetting = 7

        # Output frequency select
        self.Integer           = 0
        self.Fraction          = 0
        self.RampOn            = 0

        # Ramp up control
        self.DeviationWord_0   = 0
        self.DeviationOffset_0 = 0
        self.StepWord_0        = 0

        # Ramp down control 
        self.DeviationWord_1   = 0
        self.DeviationOffset_1 = 0
        self.StepWord_1        = 0

        # Other
        self.UseRefMul2        = 0
        self.RefCounter        = 1
        self.UseRefDiv2        = 1

        self.Clk1Divider       = 1
        self.Clk2Divider_0     = 2
        self.Clk2Divider_1     = 2

        # Convenience variables
        self.RefFreq         = 0
        self.PfdFreq         = 0
        self.StartFreq       = 10e9
        self.FeedbackVcoDiv2 = True

        self.UseRefMul2 = False
        self.UseRefDiv2 = False
    #---------------------------------------------------------------------------

    def SetStart(self, StartFreq):
        assert(self.RefFreq > 0) # Check that SetRefFreq() was called first
        self.StartFreq = StartFreq

        if(self.FeedbackVcoDiv2): Frequency = round(2.0**24 * self.StartFreq / self.PfdFreq)
        else:                Frequency = round(2.0**25 * self.StartFreq / self.PfdFreq)
        
        self.Integer  = Frequency >> 25
        self.Fraction = Frequency & 0x01FFFFFF
    #---------------------------------------------------------------------------

    def _SetRamp(self, Up, Bandwidth, Time):
        assert(self.RefFreq > 0) # Check that SetRefFreq() was called first
        
        self.Clk1Divider     = 1
        Clk2Divider     = 2
        StepWord        = 0
        DeviationOffset = 0
        DeviationWord   = 0

        Clk2Divider = self.PfdFreq / ((2**20 - 1) / Time)
        if(Clk2Divider < 2): Clk2Divider = 2
        assert(Clk2Divider < 2**12)

        StepWord = round((self.PfdFreq / Clk2Divider) * Time)
        assert(StepWord < 2**20)

        DeviationOffset = 0
        DeviationWord   = round((Bandwidth / StepWord) /
                                (self.PfdFreq   / 2**25   ) /
                                (2**DeviationOffset  ))

        while(abs(DeviationWord) >= 2**15):
            DeviationOffset += 1
            DeviationWord   /= 2
        assert(DeviationOffset < 2**4)

        if(Up):
            self.Clk2Divider_0     = Clk2Divider
            self.StepWord_0        = StepWord
            self.DeviationOffset_0 = DeviationOffset
            self.DeviationWord_0   = DeviationWord

        else:
            self.Clk2Divider_1     = Clk2Divider
            self.StepWord_1        = StepWord
            self.DeviationOffset_1 = DeviationOffset
            self.DeviationWord_1   = DeviationWord
    #---------------------------------------------------------------------------

    def SetRamp(self, Bandwidth, UpTime, DownTime):
        self._SetRamp(True , Bandwidth, UpTime  )
        self._SetRamp(False, Bandwidth, DownTime)
    #---------------------------------------------------------------------------

    # NOTE: Set this before using SetStart or SetRamp
    def SetRefFreq(self, RefFreq, FeedbackVcoDiv2 = True):
        self.RefFreq         = RefFreq
        self.FeedbackVcoDiv2 = FeedbackVcoDiv2

        self.UseRefMul2 = False
        self.UseRefDiv2 = False
        self.PfdFreq    = RefFreq

        if(self.RefFreq > 110e6):
            self.UseRefDiv2 = True
            self.PfdFreq   /= 2

        if(self.RefFreq < 55e6):
            self.UseRefMul2 = true
            self.PfdFreq  *= 2

        RefDiv = 1
        while(RefDiv < 32 and self.PfdFreq > 110e6):
            RefDiv  += 1
            self.PfdFreq /= 2

        self.RefCounter = RefDiv
        self.SetStart(self.StartFreq)
    #---------------------------------------------------------------------------

    def PrintParameters(self):
        print( '')

        print(f'Integer           = {self.Integer }')
        print(f'Fraction          = {self.Fraction}')
        print( '')

        print(f'DeviationWord_0   = {self.DeviationWord_0  }')
        print(f'DeviationOffset_0 = {self.DeviationOffset_0}')
        print(f'StepWord_0        = {self.StepWord_0       }')
        print( '')

        print(f'DeviationWord_1   = {self.DeviationWord_1  }')
        print(f'DeviationOffset_1 = {self.DeviationOffset_1}')
        print(f'StepWord_1        = {self.StepWord_1       }')
        print( '')

        print(f'UseRefMul2        = {self.UseRefMul2}')
        print(f'RefCounter        = {self.RefCounter}')
        print(f'UseRefDiv2        = {self.UseRefDiv2}')
        print( '')

        print(f'Clk1Divider       = {self.Clk1Divider  }')
        print(f'Clk2Divider_0     = {self.Clk2Divider_0}')
        print(f'Clk2Divider_1     = {self.Clk2Divider_1}')
        print( '')
#-------------------------------------------------------------------------------

