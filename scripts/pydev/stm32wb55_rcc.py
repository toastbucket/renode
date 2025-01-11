self.NoisyLog('%s @ 0x%x' % (str(request.type), request.offset))

if request.isInit:
    _regs = {
        0x0000: 0x00000061 | 0x0a021402, # RCC_CR - automatically set status bits "ready"
        0x0008: 0x00070000, # RCC_CFGR
        0x0050: 0x02080000, # RCC_AHB3ENR
        0x0090: 0x00000000 | 0x2, # RCC_BDCR - automatically set status bits "ready"
        0x0094: 0x0c000000 | 0xa, # RCC_CSR
        0x0098: 0x00000000 | 0x2, # RCC_CRRCR - automatically set status bits "ready"
        0x0108: 0x00030000, # RCC_EXTCFGR
    }
elif request.isRead:
    try:
        request.value = _regs[request.offset]
    except KeyError:
        request.value = 0
    self.NoisyLog('->returning 0x%x' % request.value)
elif request.isWrite:
    try:
        # HW needs to set SWS to match SW
        if request.offset == 0x0008:
            sw = request.value & 0x3
            request.value = (request.value & 0xfffffff0) | (sw << 2) | sw
        _regs[request.offset] = request.value
        self.NoisyLog('->wrote 0x%x' % request.value)
    except KeyError:
        self.NoisyLog('->unimplemented')
