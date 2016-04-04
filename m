Return-Path: <robert@leblancnet.us>
MIME-Version: 1.0
In-Reply-To: <5702AFBB.5030800@deltatee.com>
References: <CAANLjFrvQhEt02+7csMxnBg_fvLyJ8DWWxnAWf1MExSQTqCpMw@mail.gmail.com>
	<57013E24.8090607@kernel.dk>
	<5701599D.2090209@deltatee.com>
	<CAANLjFpbkM_zQwZ7=uHpJ0iJ_4qJSJw0dxV+z3Q_chvNNp31FQ@mail.gmail.com>
	<570294C9.1050502@deltatee.com>
	<CAANLjFqdE=4zKV2J6JFehZHEXRgte-W8kVaT+5YAWD562kWcGA@mail.gmail.com>
	<5702AFBB.5030800@deltatee.com>
Date: Mon, 4 Apr 2016 12:48:25 -0600
Message-ID: <CAANLjFq8dRa_LdbWMMok54HuXQCt=-aHWkpgwS2OtUiujGQWOA@mail.gmail.com>
Subject: Re: fio: rdma_create_event_channel fail
From: Robert LeBlanc <robert@leblancnet.us>
Content-Type: text/plain; charset=UTF-8
To: Logan Gunthorpe <logang@deltatee.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Logan,

Thanks for all your help. I was lacking the libmlx4 and libmklx5
packages. After installing those, fio started without issue. Since we
have been using all kernel space programs, we didn't run into this
dependency issue until now. We had other userspace RDMA libraries, but
was missing this piece.

Thanks again.
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.3.6
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJXArbyCRDmVDuy+mK58QAAPdUP/2Q3ZVtF39Tb9Y6CBcXo
HOvnKD/ds5pxygQ5HsXNVlpd2rYabC8TdlEJVWwaLSbJ8rl2WzKeXU3rLqRB
0XK7UWzZeyg0kZm762LwwkMLcmSoV2KN89ra6VWWbGCzPy51tPmTmcYwNbHR
hjmFGWWUNVJKD02fXNP4qjbTS+eCfWNMxvxeGv+/kkiNGHB1DuBkyykCY74N
bKCmEE3MsMznGfZT0g60ZknbbBuNdyNkw4aGYV2TZ4QxRGMnBfb16jGdmJma
ZoyfzxVUQiN2qGYnNhsPYs0/I+Qtmy8KCslp7r6bPRSJ4NmoI9HwktU8U2cS
gbGYYo4jPxVO9UMHWBJ7cnNeUYnmi+yzAWa7zGlQL3ko352W5Zef8T8AvSfz
leaZ3BFlmQZB6OideOpuLY9RGsRMP5TbFaKmysyLruaPxFoMXB8Yu/0XgBeG
3m6aLBx0zbcJkfezwZ9/RxAZm2Nd0nrxCUvEokp9kylufDQCfApKprB6CImr
cjaxIYVHN1BEu3PKqy2WdpYehLGDNCiXsAlTQTmh869XpsF3WyUW7gCePa0k
ba8qoVUeOIWZWA4iw9AiEKmBFfqNmV6PWq75NYC0KOkDTXePSCCSA6LCM7rC
RKMjQsDf0PyVxVTOeHkw7eaGp8AQ/NjuUTMjlGXQpk9cXW9py0bzeMinjYvn
hjDN
=5tGZ
-----END PGP SIGNATURE-----
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Apr 4, 2016 at 12:17 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> Hey,
>
> It looks like the ib verbs stuff isn't detecting your devices. Though
> I'm not sure why. What you've sent so far looks good. Can you also send
> the output of 'ibv_devices'? (It's from the ibverbs-utils package if you
> don't have it installed.) You may have a missing or improperly installed
> userspace driver and that command should inform you if that's the case.
>
> It's still also worth trying some of the perftest tools (ib_write_bw) to
> see if they have similar problems.
>
> Logan
>
> On 04/04/16 11:43 AM, Robert LeBlanc wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA256
>>
>> Logan,
>>
>> Here is the output from your branch. Thanks for helping with this.
>> Could the problem be due to us having multiple IB cards?
>>
>> # cat examples/rdmaio-server.fio
>> # Example rdma server job
>> [global]
>> ioengine=rdma
>> port=5557
>> bs=1m
>> size=100g
>>
>> [receiver]
>> rw=read
>> iodepth=16
>>
>> $ ./fio examples/rdmaio-server.fio
>> receiver: (g=0): rw=read, bs=1M-1M/1M-1M/1M-1M, ioengine=rdma, iodepth=16
>> fio-2.2.8-381-g2a44
>> Starting 1 process
>> fio: rdma_create_event_channel fail: No such device
>> fio: io engine init failed. Perhaps try reducing io depth?
>> fio: pid=5518, err=1/
>>
>>
>> Run status group 0 (all jobs):
>> [rleblanc@localhost fio-logan]$ ibstat
>> CA 'mlx4_0'
>>        CA type: MT4099
>>        Number of ports: 1
>>        Firmware version: 2.35.5100
>>        Hardware version: 0
>>        Node GUID: 0x0cc47affff4fe8bc
>>        System image GUID: 0x0cc47affff4fe8bf
>>        Port 1:
>>                State: Active
>>                Physical state: LinkUp
>>                Rate: 56
>>                Base lid: 58
>>                LMC: 0
>>                SM lid: 1
>>                Capability mask: 0x02594868
>>                Port GUID: 0x0cc47affff4fe8bd
>>                Link layer: InfiniBand
>> CA 'mlx5_0'
>>        CA type: MT4113
>>        Number of ports: 2
>>        Firmware version: 10.14.1100
>>        Hardware version: 0
>>        Node GUID: 0xe41d2d030006d0d0
>>        System image GUID: 0xe41d2d030006d0d0
>>        Port 1:
>>                State: Active
>>                Physical state: LinkUp
>>                Rate: 56
>>                Base lid: 56
>>                LMC: 0
>>                SM lid: 1
>>                Capability mask: 0x26596848
>>                Port GUID: 0xe41d2d030006d0d0
>>                Link layer: InfiniBand
>>        Port 2:
>>                State: Active
>>                Physical state: LinkUp
>>                Rate: 56
>>                Base lid: 57
>>                LMC: 0
>>                SM lid: 1
>>                Capability mask: 0x26596848
>>                Port GUID: 0xe41d2d030006d0d8
>>                Link layer: InfiniBand
>>
>> # lsmod
>> Module                  Size  Used by
>> ebtable_filter         16384  0
>> ebtables               36864  1 ebtable_filter
>> ip6table_filter        16384  0
>> ip6_tables             28672  1 ip6table_filter
>> iptable_filter         16384  0
>> iptable_raw            16384  0
>> xprtrdma               53248  0
>> ib_isert               57344  0
>> iscsi_target_mod      294912  1 ib_isert
>> ib_iser                53248  0
>> ib_srpt                53248  0
>> target_core_mod       372736  3 iscsi_target_mod,ib_srpt,ib_isert
>> ib_srp                 49152  0
>> scsi_transport_srp     24576  1 ib_srp
>> ib_ipoib               94208  0
>> rdma_ucm               24576  0
>> ib_ucm                 24576  0
>> ib_uverbs              49152  2 ib_ucm,rdma_ucm
>> ib_umad                24576  0
>> rdma_cm                45056  4 xprtrdma,ib_iser,rdma_ucm,ib_isert
>> ib_cm                  49152  5 rdma_cm,ib_srp,ib_ucm,ib_srpt,ib_ipoib
>> iw_cxgb4              172032  0
>> iw_cm                  45056  2 iw_cxgb4,rdma_cm
>> iw_cxgb3              126976  0
>> mlx5_ib               110592  0
>> mlx4_ib               151552  0
>> ib_sa                  36864  6 rdma_cm,ib_cm,mlx4_ib,ib_srp,rdma_ucm,ib_ipoib
>> ib_mad                 49152  5 ib_cm,ib_sa,mlx4_ib,ib_srpt,ib_umad
>> ib_core               102400  19
>> iw_cxgb3,iw_cxgb4,rdma_cm,ib_cm,ib_sa,iw_cm,xprtrdma,mlx4_ib,mlx5_ib,ib_mad,ib_srp,ib_ucm,ib_iser,ib_srpt,ib_umad,ib_uverbs,rdma_ucm,ib_ipoib,ib_isert
>> ib_addr                20480  3 rdma_cm,ib_core,rdma_ucm
>> ipmi_devintf           20480  2
>> kvm_intel             155648  0
>> kvm                   495616  1 kvm_intel
>> coretemp               16384  0
>> iTCO_wdt               16384  0
>> intel_powerclamp       16384  0
>> iTCO_vendor_support    16384  1 iTCO_wdt
>> sb_edac                28672  0
>> x86_pkg_temp_thermal    16384  0
>> joydev                 20480  0
>> sg                     40960  0
>> pcspkr                 16384  0
>> lpc_ich                24576  0
>> edac_core              61440  1 sb_edac
>> i2c_i801               20480  0
>> mfd_core               16384  1 lpc_ich
>> ipmi_si                57344  1
>> 8250_fintek            16384  0
>> acpi_power_meter       20480  0
>> ipmi_msghandler        49152  2 ipmi_devintf,ipmi_si
>> acpi_pad              180224  0
>> mei_me                 24576  0
>> mei                    90112  1 mei_me
>> ioatdma                69632  0
>> shpchp                 40960  0
>> ip_tables              28672  2 iptable_filter,iptable_raw
>> xfs                   929792  1
>> libcrc32c              16384  1 xfs
>> raid1                  40960  1
>> sd_mod                 40960  2
>> mlx4_en               110592  0
>> vxlan                  45056  1 mlx4_en
>> ip6_udp_tunnel         16384  1 vxlan
>> udp_tunnel             16384  1 vxlan
>> crc32_pclmul           16384  0
>> ast                    61440  1
>> syscopyarea            16384  1 ast
>> sysfillrect            16384  1 ast
>> aesni_intel           172032  0
>> sysimgblt              16384  1 ast
>> drm_kms_helper        126976  1 ast
>> lrw                    16384  1 aesni_intel
>> gf128mul               16384  1 lrw
>> glue_helper            16384  1 aesni_intel
>> ablk_helper            16384  1 aesni_intel
>> ttm                    94208  1 ast
>> igb                   196608  0
>> ahci                   36864  0
>> cryptd                 20480  2 aesni_intel,ablk_helper
>> ptp                    20480  2 igb,mlx4_en
>> crct10dif_pclmul       16384  0
>> libahci                32768  1 ahci
>> drm                   352256  4 ast,ttm,drm_kms_helper
>> crc32c_intel           24576  9
>> mlx5_core             102400  1 mlx5_ib
>> pps_core               20480  1 ptp
>> mlx4_core             286720  2 mlx4_en,mlx4_ib
>> libata                245760  2 ahci,libahci
>> i2c_algo_bit           16384  2 ast,igb
>> dca                    16384  2 igb,ioatdma
>> wmi                    20480  0
>> sunrpc                327680  2 xprtrdma
>> dm_mirror              24576  0
>> dm_region_hash         24576  1 dm_mirror
>> dm_log                 20480  2 dm_region_hash,dm_mirror
>> dm_mod                110592  2 dm_log,dm_mirror
>> iscsi_tcp              20480  4
>> zfs                  2826240  0
>> be2iscsi              114688  0
>> bnx2i                  57344  0
>> cnic                   65536  1 bnx2i
>> uio                    20480  1 cnic
>> cxgb4                 204800  1 iw_cxgb4
>> cxgb3                 159744  1 iw_cxgb3
>> libcxgbi               65536  0
>> libiscsi_tcp           28672  2 iscsi_tcp,libcxgbi
>> mdio                   16384  1 cxgb3
>> qla4xxx               286720  0
>> iscsi_boot_sysfs       16384  2 qla4xxx,be2iscsi
>> libiscsi               57344  7
>> qla4xxx,libiscsi_tcp,bnx2i,be2iscsi,iscsi_tcp,ib_iser,libcxgbi
>> scsi_transport_iscsi   102400  8
>> qla4xxx,bnx2i,be2iscsi,iscsi_tcp,ib_iser,libcxgbi,libiscsi
>> zunicode              331776  1 zfs
>> zcommon                57344  1 zfs
>> znvpair                94208  2 zfs,zcommon
>> spl                    98304  3 zfs,zcommon,znvpair
>> zavl                   16384  1 zfs
>> -----BEGIN PGP SIGNATURE-----
>> Version: Mailvelope v1.3.6
>> Comment: https://www.mailvelope.com
>>
>> wsFcBAEBCAAQBQJXAqeiCRDmVDuy+mK58QAAeNoP/1pFkBV3piTGx9WPtXLA
>> cK+SLIVirFcX1QcxJOSjXjYkTvHNwFgg5YzWbpQqN7ZzzEmt8baUiDeolTrD
>> SwIKxE+SBS8qHGiFLndY2fO//poYevFAdq1JgYVGokv2eSvsrAJDR8snEJ/a
>> qjA38VIIA3UoHE3ABDGgKO/vYE6dZZBfYHQRFIhp5tvDyFaCZzw8RGZWY7FR
>> 9iTyQhONJxYV3oStTtmeM2B9txl+8HfdTTPpZXZsNZ0g8DKyF78gksBNfv4v
>> HJYwLUhZBQNPlHhR82a9mxMvecaNBlyA33k4+uWjUieSX66YGwt+tn5vXl/k
>> RY8QwchYI8v4642wPKCqXy+SAjJDn45wp4z/Z9Gx2cJfQFNw3c1rpHugINBF
>> Ri+CS2IWG3ucCrn3K+Nqmu+SvH051j1xoyozZzBmLeMXILVLq2Fd93cjpN7r
>> XVlmyZJ8kVyMoUwNkX/hRHVL4QRFP2vNKI2dOA0AfXgYOaMKrMUaAVmBWAMO
>> XnyInJGR1ReUTZKMITdlNTn4lAoaYV3lug/1Uxk31T+hNhvS2uEBnK/JKv12
>> QAO1Scl3dnD7uiMgtmoXp8jtCisd1N2jB6qblG4IVU22U8ROkfHxwmaHoHVr
>> 5n4F/0WcY2SZVmwhKskX0bl0/bW8CWbeSb1LDEx67uPcTJk31Io9NE9rJQU6
>> m4nq
>> =pwG4
>> -----END PGP SIGNATURE-----
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Mon, Apr 4, 2016 at 10:22 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>>> Hey,
>>>
>>> I've created a patch on github that will print slightly more information
>>> in the error message. If you could try it and post the output it may
>>> shine some more light on the situation:
>>>
>>> https://github.com/axboe/fio/pull/160
>>> https://github.com/lsgunth/fio/tree/rdma_err
>>>
>>> It may also be worth sending the output of ibstat and maybe lsmod as well.
>>>
>>> Logan
>>>
>>>
>>> On 03/04/16 04:38 PM, Robert LeBlanc wrote:
>>>> I'm able to do ibstat and everything is up. I can do ibping between the
>>>> nodes and iSER is working properly. I have not done ib_write_bw but I
>>>> can try it tomorrow if you think it would help.
>>>>
>>>> I included the entire message from fio. Can you give me some more
>>>> information about additional error messages you may needed.
>>>>
>>>> Sent from a mobile device, please excuse any typos.
>>>>
>>>> On Apr 3, 2016 11:57 AM, "Logan Gunthorpe" <logang@deltatee.com
>>>> <mailto:logang@deltatee.com>> wrote:
>>>>
>>>>     Hi Robert,
>>>>
>>>>     It looks like rdma_create_event_channel has failed which is a pretty
>>>>     basic part of the RDMA initialization. To me, this likely indicates
>>>>     your RDMA setup is broken. Do commands like ibstatus and ibv_devices
>>>>     report active interfaces? Do other RDMA test programs like
>>>>     ib_write_bw, etc (from the perftest package) work?
>>>>
>>>>     It may be worth printing the errno with that error message, I may
>>>>     have time to make a patch to that effect tomorrow.
>>>>
>>>>     Logan
>>>>
>>>>     On 03/04/16 10:00 AM, Jens Axboe wrote:
>>>>
>>>>         CC'ing Logan, who might have an idea.
>>>>
>>>>
>>>>         On 03/31/2016 10:44 AM, Robert LeBlanc wrote:
>>>>
>>>>             -----BEGIN PGP SIGNED MESSAGE-----
>>>>             Hash: SHA256
>>>>
>>>>             When trying to use the RDMA engine and the example job for
>>>>             the server
>>>>             with the port set to an arbitrary value I get:
>>>>
>>>>             # /home/rleblanc/fio/fio
>>>>             /home/rleblanc/fio/examples/rdmaio-server.fio
>>>>             receiver: (g=0): rw=read, bs=1M-1M/1M-1M/1M-1M,
>>>>             ioengine=rdma, iodepth=16
>>>>             fio-2.8-14-g23a8
>>>>             Starting 1 process
>>>>             fio: rdma_create_event_channel fail
>>>>             fio: io engine init failed. Perhaps try reducing io depth?
>>>>             fio: pid=18588, err=1/
>>>>
>>>>             Setting I/O depth=1 only removed the corresponding message
>>>>             from the
>>>>             output.
>>>>             # uname -r
>>>>             4.1.15.bs.ufd
>>>>
>>>>             # rpm -qa | grep -E "ibverbs|rdmacm"
>>>>             libibverbs-devel-1.1.8-8.el7.x86_64
>>>>             librdmacm-1.0.21-1.el7.x86_64
>>>>             libibverbs-1.1.8-8.el7.x86_64
>>>>             librdmacm-devel-1.0.21-1.el7.x86_64
>>>>
>>>>             I'm not sure what is wrong as this is the first time I've
>>>>             tried using
>>>>             the RDMA engine.
>>>>             - ----------------
>>>>             Robert LeBlanc
>>>>             PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2
>>>>             FA62 B9F1
>>>>             -----BEGIN PGP SIGNATURE-----
>>>>             Version: Mailvelope v1.3.6
>>>>             Comment: https://www.mailvelope.com
>>>>
>>>>             wsFcBAEBCAAQBQJW/VPPCRDmVDuy+mK58QAAPKMQAJF8B3y8pk9l2emtsrGm
>>>>             2Rt7ufstv6c4XtuCk2wsc6ocZe8yNfAM1BNkW6pTF96orHZuLTt/QDvbDlnN
>>>>             q6N0vPkGJbDVbm7YNDzFc4qOU1pbrn8a66eck5BKuHPPogXCsJJTu+rdfAd9
>>>>             TNUGD4b9MzogTCzI8Zs6YRdWLIeaJRsPaHqJGYsD5G83rxGFagjx0qoOPuF+
>>>>             CNcFVYXZeU3+/YzsTDfuvNtiSDDJTUe3Shjw6fSu8ZFNabucAbbGOflovIIL
>>>>             kGjFmprrFgqOLiTnw7muF6tSXcc205YMGbCgOiEye4i9Ajd/ITiEQ3QlbQZ1
>>>>             WDz5WPSukDR8KqJoREKcksWVL7zVciulE5/+ZlJajD02JfOTz7j9QydLAPJ/
>>>>             sQM1g7Ft5HZK8TB9IgVKBernHCpahNQ5dU2OadDgpe0rxjzjrVcxegYOqLPd
>>>>             iUVFT2/UUFwzxaVnxHXTDNGO5A4JSyctvPTQ4uKLFFox9p6L5pFgrz9o86Fs
>>>>             lbW/72IjJD/8AEC64cqJp6JuC/sSEmz2hPpOvKdbpWPlVijzPB0OnpkMB4cC
>>>>             DATo4afT5uDRDe7IS8Ypi/WcriVLA+O9jRsigARri1F4FFc1QR/FDtXQnKYE
>>>>             SKB8sOE6sAv8qsyNLDqyD3rAzjRJ267zweNcWficcrHD3pYljXCLK1oaZgHD
>>>>             EcOB
>>>>             =f1X7
>>>>             -----END PGP SIGNATURE-----
>>>>             --
>>>>             To unsubscribe from this list: send the line "unsubscribe
>>>>             fio" in
>>>>             the body of a message to majordomo@vger.kernel.org
>>>>             <mailto:majordomo@vger.kernel.org>
>>>>             More majordomo info at
>>>>             http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>

