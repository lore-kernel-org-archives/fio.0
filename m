Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34020 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbcF0VVP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 27 Jun 2016 17:21:15 -0400
Received: by mail-vk0-f42.google.com with SMTP id c2so218881185vkg.1
        for <fio@vger.kernel.org>; Mon, 27 Jun 2016 14:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP8ELLWHUR5_Zia8X03eOotDUW8M-5u3pA_ie=sXD8cvwh1e5g@mail.gmail.com>
References: <CAP8ELLWHUR5_Zia8X03eOotDUW8M-5u3pA_ie=sXD8cvwh1e5g@mail.gmail.com>
From: Frank Londono <flonclondono@gmail.com>
Date: Mon, 27 Jun 2016 14:20:53 -0700
Message-ID: <CAP8ELLVPLs59wFTix0h4CBoS1ZQ7A5Fj8V_t-V+UUSusENb11A@mail.gmail.com>
Subject: Fwd: fio bug
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Just started using tkperf/fio, and am the system crashes:

Running TKperf:
sudo tkperf ssd toshiba1 /dev/sdb


ubuntu 16.04 LTS
Memory 5.8GiB
Processor Intel® Xeon(TM) CPU 3.00GHz × 4
Graphics R100 (RV100 5159)  DRI2
OS type 64-bit
Disk 240.6 GB

uname -a
Linux drivequal6 4.4.0-24-generic #43-Ubuntu SMP Wed Jun 8 19:27:37
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

fio --version
fio-2.2.10


tail toshiba.log
INFO:root:######
INFO:root:#################
INFO:root:Round nr. 4
INFO:root:['/usr/bin/fio', '--rw=randrw', '--name=toshiba1',
'--bs=8k', '--direct=1', '--filename=/dev/sdb', '--rwmixread=100',
'--numjobs=1', '--ioengine=libaio', '--runtime=60', '--iodepth=1',
'--minimal', '--time_based', '--group_reporting']
INFO:root:mixLoad: 100
INFO:root:bs: 8k
INFO:root:
INFO:root:######


++++++++++++++

syslog output:

Jun 27 12:02:14 qual6 org.debian.apt[1424]: 12:02:14 AptDaemon.Worker
[INFO]: Finished transaction /org/debian/apt/transaction/
Jun 27 12:02:44 qual6 kernel: [ 1939.769050] swap_free: Bad swap
offset entry 8641b9fff80
Jun 27 12:02:44 qual6 kernel: [ 1939.769059] BUG: Bad page map in
process fio  pte:10c8373fff0040 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769063] addr:00007ff321a00000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab2
Jun 27 12:02:44 qual6 kernel: [ 1939.769073] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769078] CPU: 0 PID: 3005 Comm:
fio Not tainted 4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769081] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
Jun 27 12:02:44 qual6 kernel: [ 1939.769084]  0000000000000286
0000000063f6c1a4 ffff880196f97c38 ffffffff813eab23
Jun 27 12:02:44 qual6 kernel: [ 1939.769090]  00007ff321a00000
ffff880196eb2578 ffff880196f97c88 ffffffff811bc32f
Jun 27 12:02:44 qual6 kernel: [ 1939.769095]  ffff880196f97c60
ffffffff811d33e0 000008641b9fff80 0010c8373fff0040
Jun 27 12:02:44 qual6 kernel: [ 1939.769099] Call Trace:
Jun 27 12:02:44 qual6 kernel: [ 1939.769109]  [<ffffffff813eab23>]
dump_stack+0x63/0x90
Jun 27 12:02:44 qual6 kernel: [ 1939.769115]  [<ffffffff811bc32f>]
print_bad_pte+0x1df/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769121]  [<ffffffff811d33e0>] ?
swap_info_get+0xb0/0xd0
Jun 27 12:02:44 qual6 kernel: [ 1939.769125]  [<ffffffff811bdcb8>]
unmap_page_range+0x468/0x7a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769129]  [<ffffffff811be06d>]
unmap_single_vma+0x7d/0xe0
Jun 27 12:02:44 qual6 kernel: [ 1939.769133]  [<ffffffff811beb31>]
unmap_vmas+0x51/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769136]  [<ffffffff811c45bc>]
unmap_region+0xac/0x120
Jun 27 12:02:44 qual6 kernel: [ 1939.769141]  [<ffffffff81223cd0>] ?
__dentry_kill+0x160/0x1e0
Jun 27 12:02:44 qual6 kernel: [ 1939.769145]  [<ffffffff811c6aca>]
do_munmap+0x28a/0x480
Jun 27 12:02:44 qual6 kernel: [ 1939.769149]  [<ffffffff8132c9d2>]
SyS_shmdt+0xb2/0x170
Jun 27 12:02:44 qual6 kernel: [ 1939.769156]  [<ffffffff81825bf2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 27 12:02:44 qual6 kernel: [ 1939.769159] Disabling lock debugging
due to kernel taint
Jun 27 12:02:44 qual6 kernel: [ 1939.769161] swap_free: Bad swap
offset entry 1f800000
Jun 27 12:02:44 qual6 kernel: [ 1939.769164] BUG: Bad page map in
process fio  pte:3f00000000 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769167] addr:00007ff321a01000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab3
Jun 27 12:02:44 qual6 kernel: [ 1939.769172] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769175] CPU: 0 PID: 3005 Comm:
fio Tainted: G    B           4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769178] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
Jun 27 12:02:44 qual6 kernel: [ 1939.769180]  0000000000000286
0000000063f6c1a4 ffff880196f97c38 ffffffff813eab23
Jun 27 12:02:44 qual6 kernel: [ 1939.769184]  00007ff321a01000
ffff880196eb2578 ffff880196f97c88 ffffffff811bc32f
Jun 27 12:02:44 qual6 kernel: [ 1939.769188]  ffff880196f97c60
ffffffff811d33e0 000000001f800000 0000003f00000000
Jun 27 12:02:44 qual6 kernel: [ 1939.769192] Call Trace:
Jun 27 12:02:44 qual6 kernel: [ 1939.769196]  [<ffffffff813eab23>]
dump_stack+0x63/0x90
Jun 27 12:02:44 qual6 kernel: [ 1939.769200]  [<ffffffff811bc32f>]
print_bad_pte+0x1df/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769204]  [<ffffffff811d33e0>] ?
swap_info_get+0xb0/0xd0
Jun 27 12:02:44 qual6 kernel: [ 1939.769208]  [<ffffffff811bdcb8>]
unmap_page_range+0x468/0x7a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769212]  [<ffffffff811be06d>]
unmap_single_vma+0x7d/0xe0
Jun 27 12:02:44 qual6 kernel: [ 1939.769216]  [<ffffffff811beb31>]
unmap_vmas+0x51/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769219]  [<ffffffff811c45bc>]
unmap_region+0xac/0x120
Jun 27 12:02:44 qual6 kernel: [ 1939.769223]  [<ffffffff81223cd0>] ?
__dentry_kill+0x160/0x1e0
Jun 27 12:02:44 qual6 kernel: [ 1939.769226]  [<ffffffff811c6aca>]
do_munmap+0x28a/0x480
Jun 27 12:02:44 qual6 kernel: [ 1939.769230]  [<ffffffff8132c9d2>]
SyS_shmdt+0xb2/0x170
Jun 27 12:02:44 qual6 kernel: [ 1939.769234]  [<ffffffff81825bf2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 27 12:02:44 qual6 kernel: [ 1939.769237] swap_free: Bad swap
offset entry 10101010000000
Jun 27 12:02:44 qual6 kernel: [ 1939.769240] BUG: Bad page map in
process fio  pte:2020202000000000 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769243] addr:00007ff321a02000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab4
Jun 27 12:02:44 qual6 kernel: [ 1939.769247] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769251] CPU: 0 PID: 3005 Comm:
fio Tainted: G    B           4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769253] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
Jun 27 12:02:44 qual6 kernel: [ 1939.769255]  0000000000000286
0000000063f6c1a4 ffff880196f97c38 ffffffff813eab23
Jun 27 12:02:44 qual6 kernel: [ 1939.769259]  00007ff321a02000
ffff880196eb2578 ffff880196f97c88 ffffffff811bc32f
Jun 27 12:02:44 qual6 kernel: [ 1939.769263]  ffff880196f97c60
ffffffff811d33e0 0010101010000000 2020202000000000
Jun 27 12:02:44 qual6 kernel: [ 1939.769267] Call Trace:
Jun 27 12:02:44 qual6 kernel: [ 1939.769271]  [<ffffffff813eab23>]
dump_stack+0x63/0x90
Jun 27 12:02:44 qual6 kernel: [ 1939.769275]  [<ffffffff811bc32f>]
print_bad_pte+0x1df/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769279]  [<ffffffff811d33e0>] ?
swap_info_get+0xb0/0xd0
Jun 27 12:02:44 qual6 kernel: [ 1939.769283]  [<ffffffff811bdcb8>]
unmap_page_range+0x468/0x7a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769287]  [<ffffffff811be06d>]
unmap_single_vma+0x7d/0xe0
Jun 27 12:02:44 qual6 kernel: [ 1939.769290]  [<ffffffff811beb31>]
unmap_vmas+0x51/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769293]  [<ffffffff811c45bc>]
unmap_region+0xac/0x120
Jun 27 12:02:44 qual6 kernel: [ 1939.769297]  [<ffffffff81223cd0>] ?
__dentry_kill+0x160/0x1e0
Jun 27 12:02:44 qual6 kernel: [ 1939.769300]  [<ffffffff811c6aca>]
do_munmap+0x28a/0x480
Jun 27 12:02:44 qual6 kernel: [ 1939.769304]  [<ffffffff8132c9d2>]
SyS_shmdt+0xb2/0x170
Jun 27 12:02:44 qual6 kernel: [ 1939.769308]  [<ffffffff81825bf2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 27 12:02:44 qual6 kernel: [ 1939.769311] swap_free: Bad swap file
entry 201a29ac1a901010
Jun 27 12:02:44 qual6 kernel: [ 1939.769314] BUG: Bad page map in
process fio  pte:3453583520202020 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769317] addr:00007ff321a03000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab5
Jun 27 12:02:44 qual6 kernel: [ 1939.769321] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769324] CPU: 0 PID: 3005 Comm:
fio Tainted: G    B           4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769327] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
Jun 27 12:02:44 qual6 kernel: [ 1939.769329]  0000000000000286
0000000063f6c1a4 ffff880196f97c38 ffffffff813eab23
Jun 27 12:02:44 qual6 kernel: [ 1939.769333]  00007ff321a03000
ffff880196eb2578 ffff880196f97c88 ffffffff811bc32f
Jun 27 12:02:44 qual6 kernel: [ 1939.769337]  ffff880196f97c60
ffffffff811d33ac 201a29ac1a901010 3453583520202020
Jun 27 12:02:44 qual6 kernel: [ 1939.769341] Call Trace:
Jun 27 12:02:44 qual6 kernel: [ 1939.769345]  [<ffffffff813eab23>]
dump_stack+0x63/0x90
Jun 27 12:02:44 qual6 kernel: [ 1939.769349]  [<ffffffff811bc32f>]
print_bad_pte+0x1df/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769353]  [<ffffffff811d33ac>] ?
swap_info_get+0x7c/0xd0
Jun 27 12:02:44 qual6 kernel: [ 1939.769357]  [<ffffffff811bdcb8>]
unmap_page_range+0x468/0x7a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769361]  [<ffffffff811be06d>]
unmap_single_vma+0x7d/0xe0
Jun 27 12:02:44 qual6 kernel: [ 1939.769364]  [<ffffffff811beb31>]
unmap_vmas+0x51/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769367]  [<ffffffff811c45bc>]
unmap_region+0xac/0x120
Jun 27 12:02:44 qual6 kernel: [ 1939.769371]  [<ffffffff81223cd0>] ?
__dentry_kill+0x160/0x1e0
Jun 27 12:02:44 qual6 kernel: [ 1939.769374]  [<ffffffff811c6aca>]
do_munmap+0x28a/0x480
Jun 27 12:02:44 qual6 kernel: [ 1939.769378]  [<ffffffff8132c9d2>]
SyS_shmdt+0xb2/0x170
Jun 27 12:02:44 qual6 kernel: [ 1939.769382]  [<ffffffff81825bf2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 27 12:02:44 qual6 kernel: [ 1939.769385] BUG: Bad page map in
process fio  pte:4c57545631433130 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769389] addr:00007ff321a04000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab6
Jun 27 12:02:44 qual6 kernel: [ 1939.769392] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769396] CPU: 0 PID: 3005 Comm:
fio Tainted: G    B           4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769398] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
Jun 27 12:02:44 qual6 kernel: [ 1939.769400]  0000000000000286
0000000063f6c1a4 ffff880196f97c20 ffffffff813eab23
Jun 27 12:02:44 qual6 kernel: [ 1939.769404]  00007ff321a04000
ffff880196eb2578 ffff880196f97c70 ffffffff811bc32f
Jun 27 12:02:44 qual6 kernel: [ 1939.769408]  00007ff321a03000
ffff880196f97c88 ffffffff811bc33e 3453583520202020
Jun 27 12:02:44 qual6 kernel: [ 1939.769412] Call Trace:
Jun 27 12:02:44 qual6 kernel: [ 1939.769416]  [<ffffffff813eab23>]
dump_stack+0x63/0x90
Jun 27 12:02:44 qual6 kernel: [ 1939.769420]  [<ffffffff811bc32f>]
print_bad_pte+0x1df/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769424]  [<ffffffff811bc33e>] ?
print_bad_pte+0x1ee/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769427]  [<ffffffff811bd803>]
vm_normal_page+0x53/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769431]  [<ffffffff811bdccc>]
unmap_page_range+0x47c/0x7a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769435]  [<ffffffff811be06d>]
unmap_single_vma+0x7d/0xe0
Jun 27 12:02:44 qual6 kernel: [ 1939.769438]  [<ffffffff811beb31>]
unmap_vmas+0x51/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769441]  [<ffffffff811c45bc>]
unmap_region+0xac/0x120
Jun 27 12:02:44 qual6 kernel: [ 1939.769445]  [<ffffffff81223cd0>] ?
__dentry_kill+0x160/0x1e0
Jun 27 12:02:44 qual6 kernel: [ 1939.769448]  [<ffffffff811c6aca>]
do_munmap+0x28a/0x480
Jun 27 12:02:44 qual6 kernel: [ 1939.769452]  [<ffffffff8132c9d2>]
SyS_shmdt+0xb2/0x170
Jun 27 12:02:44 qual6 kernel: [ 1939.769456]  [<ffffffff81825bf2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 27 12:02:44 qual6 kernel: [ 1939.769459] swap_free: Bad swap
offset entry 1c228000000000
Jun 27 12:02:44 qual6 kernel: [ 1939.769462] BUG: Bad page map in
process fio  pte:3845000000000000 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769465] addr:00007ff321a05000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab7
Jun 27 12:02:44 qual6 kernel: [ 1939.769469] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769472] CPU: 0 PID: 3005 Comm:
fio Tainted: G    B           4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769474] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
Jun 27 12:02:44 qual6 kernel: [ 1939.769476]  0000000000000286
0000000063f6c1a4 ffff880196f97c38 ffffffff813eab23
Jun 27 12:02:44 qual6 kernel: [ 1939.769481]  00007ff321a05000
ffff880196eb2578 ffff880196f97c88 ffffffff811bc32f
Jun 27 12:02:44 qual6 kernel: [ 1939.769485]  ffff880196f97c60
ffffffff811d33e0 001c228000000000 3845000000000000
Jun 27 12:02:44 qual6 kernel: [ 1939.769489] Call Trace:
Jun 27 12:02:44 qual6 kernel: [ 1939.769493]  [<ffffffff813eab23>]
dump_stack+0x63/0x90
Jun 27 12:02:44 qual6 kernel: [ 1939.769497]  [<ffffffff811bc32f>]
print_bad_pte+0x1df/0x2a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769500]  [<ffffffff811d33e0>] ?
swap_info_get+0xb0/0xd0
Jun 27 12:02:44 qual6 kernel: [ 1939.769504]  [<ffffffff811bdcb8>]
unmap_page_range+0x468/0x7a0
Jun 27 12:02:44 qual6 kernel: [ 1939.769508]  [<ffffffff811be06d>]
unmap_single_vma+0x7d/0xe0
Jun 27 12:02:44 qual6 kernel: [ 1939.769512]  [<ffffffff811beb31>]
unmap_vmas+0x51/0xa0
Jun 27 12:02:44 qual6 kernel: [ 1939.769515]  [<ffffffff811c45bc>]
unmap_region+0xac/0x120
Jun 27 12:02:44 qual6 kernel: [ 1939.769518]  [<ffffffff81223cd0>] ?
__dentry_kill+0x160/0x1e0
Jun 27 12:02:44 qual6 kernel: [ 1939.769522]  [<ffffffff811c6aca>]
do_munmap+0x28a/0x480
Jun 27 12:02:44 qual6 kernel: [ 1939.769525]  [<ffffffff8132c9d2>]
SyS_shmdt+0xb2/0x170
Jun 27 12:02:44 qual6 kernel: [ 1939.769529]  [<ffffffff81825bf2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 27 12:02:44 qual6 kernel: [ 1939.769533] BUG: Bad page map in
process fio  pte:544f303136314554 pmd:335c5067
Jun 27 12:02:44 qual6 kernel: [ 1939.769536] addr:00007ff321a06000
vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
index:3ab8
Jun 27 12:02:44 qual6 kernel: [ 1939.769540] file:SYSV00000000
fault:shm_fault mmap:shm_mmap readpage:          (null)
Jun 27 12:02:44 qual6 kernel: [ 1939.769543] CPU: 0 PID: 3005 Comm:
fio Tainted: G    B           4.4.0-24-generic #43-Ubuntu
Jun 27 12:02:44 qual6 kernel: [ 1939.769546] Hardware name: Dell
Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
