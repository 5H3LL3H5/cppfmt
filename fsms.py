class base_fsm():

    state = []
    marks = []
    endflag = False

    def run(self, units):
        scfunc = self.state[0]
        tmpmark = []
        count = 0
        
        for unit in units:
            tmpmark.append(count)
            st = scfunc(unit)
            
            if self.endflag == True:
                self.marks.append(tmpmark)
                self.endflag = False
            
            if st == 0:
                tmpmark = []
            
            scfunc = self.state[st]
            count += 1

    def generate(self, units, type):
        delcount = 0
        
        for mark in self.marks:
            head = mark[0]
            for i in mark:
                if i == head:
                    units[i].type = type
                else:
                    units[head].value += units[i].value
        
        for mark in self.marks:
            head = mark[0]
            head -= delcount
            for index in range(1, len(mark)):
                del units[head+1]
                delcount += 1


class LBCOMMENT_fsm(base_fsm):

    def __init__(self):
        self.state.append(self.begin_state)
        self.state.append(self.end_state)

    def begin_state(self, unit):
        if unit.type == 'DIVIDE':
            return 1
        else:
            return 0

    def end_state(self, unit):
        if unit.type == 'TIMES':
            self.endflag = True
            return 0
        else:
            return 0


class RBCOMMENT_fsm(base_fsm):

    def __init__(self):
        self.state.append(self.begin_state)
        self.state.append(self.end_state)

    def begin_state(self, unit):
        if unit.type == 'TIMES':
            return 1
        else:
            return 0

    def end_state(self, unit):
        if unit.type == 'DIVIDE':
            self.endflag = True
            return 0
        else:
            return 0
