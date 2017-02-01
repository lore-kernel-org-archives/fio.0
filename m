Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:63981 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdBAQqL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Feb 2017 11:46:11 -0500
Received: from mail.micron.com (bowex36c.micron.com [137.201.84.132])
        by mailout.micron.com (8.14.4/8.14.6) with ESMTP id v11Gk9gG017493
        for <fio@vger.kernel.org>; Wed, 1 Feb 2017 09:46:09 -0700
From: "Prabhu Murugesan (pmurugesan)" <pmurugesan@micron.com>
Subject: not all the jobs running at equal speed
Date: Wed, 1 Feb 2017 16:46:09 +0000
Message-ID: <cd5deac3ce8b4c6da58b3f720f88941c@bowex36c.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I am trying to run 4 jobs in parallel in order to fill a drive once randomly. The dut that I am using is a 450GB NVMe drive. The problem is, not all the jobs are running at equal speed. You can find iops log file data for all the jobs below

1000	50141	1	0		1000	17565	1	0		1000	50780	1	0		1000	16515	1	0
2002	47035	1	0		2002	13791	1	0		2002	46933	1	0		2002	13957	1	0
3003	44732	1	0		3003	12177	1	0		3003	44685	1	0		3003	13064	1	0
4003	49555	1	0		4003	15711	1	0		4003	49373	1	0		4003	14064	1	0
5003	48453	1	0		5003	15086	1	0		5003	48567	1	0		5003	13252	1	0
6003	51174	1	0		6003	14598	1	0		6003	51143	1	0		6003	15082	1	0
7003	48859	1	0		7003	15395	1	0		7003	49030	1	0		7004	14277	1	0
8003	49137	1	0		8004	14067	1	0		8003	48463	1	0		8004	13911	1	0
9003	49469	1	0		9004	15553	1	0		9003	49407	1	0		9004	16889	1	0
10003	48230	1	0		10005	15270	1	0		10003	48190	1	0		10005	14697	1	0

The fio configuration for the above result is shown below.
#################################
[global]
ioengine=libaio					
clat_percentiles=1				
percentile_list=95.0:99.0:99.5:99.9:99.99:99.999:99.9999	
disable_slat=1					
disable_lat=1					
thread							
cpus_allowed=0-7
cpus_allowed_policy=split
direct=1					
bs=4k						
ba=4k						
iodepth=64
size=112524539904
unified_rw_reporting=1
group_reporting=1
log_avg_msec=1000
rw=randwrite
randrepeat=0 
norandommap 
refill_buffers
write_bw_log=4k-4k_randwrite_0_rd_qd256
write_iops_log=4k-4k_randwrite_0_rd_qd256
write_lat_log=4k-4k_randwrite_0_rd_qd256

[4k-4k_randwrite_0_rd_qd256]
offset=0

[4k-4k_randwrite_0_rd_qd256]
offset=112524539904

[4k-4k_randwrite_0_rd_qd256]
offset=225049079808

[4k-4k_randwrite_0_rd_qd256]
offset=337573619712
#################################

On the othe side, if I run using the 'numjobs' parameter, I am seeing kind of equal speed.

1000	37314	1	0		1000	37891	1	0		1000	38008	1	0		1000	37970	1	0
2000	36690	1	0		2000	36694	1	0		2000	36703	1	0		2000	36679	1	0
3006	40208	1	0		3006	40211	1	0		3006	40209	1	0		3006	40207	1	0
4006	40490	1	0		4006	40490	1	0		4006	40480	1	0		4006	40491	1	0
5006	38955	1	0		5006	38952	1	0		5006	38961	1	0		5006	38958	1	0
6007	40845	1	0		6007	40841	1	0		6007	40835	1	0		6007	40844	1	0
7007	39602	1	0		7007	39584	1	0		7007	39624	1	0		7007	39614	1	0
8007	38667	1	0		8008	38729	1	0		8007	38666	1	0		8007	38673	1	0
9007	40633	1	0		9008	40620	1	0		9007	40634	1	0		9007	40638	1	0
10007	39586	1	0		10009	39610	1	0		10007	39578	1	0		10007	39572	1	0

The configuration can be found below.
[global]
# pass in the filename on the command line with --filename switch based on user selection
#filename=\\.\PhysicalDrive1	# test PhysicalDrive1
#ioengine=windowsaio			# Default engine for WindowsIO
ioengine=libaio					# Default engine for CentOS
clat_percentiles=1				# report QOS data, on by default
percentile_list=95.0:99.0:99.5:99.9:99.99:99.999:99.9999	# defines percentile buckets in mS
disable_slat=1					# disables Submission Latency recording
disable_lat=1					# disables Total Latency recording
thread							# fork threads rather than jobs (windows can only fork threads)
cpus_allowed=0-7
cpus_allowed_policy=split
direct=1						# Uses direct IO's, bypass OS buffer
#gtod_cpu=1						# dedicate a core to time-keeping

# Captures one of the four corners on an empty/FOB drive
[4k-4k_randwrite_0_rd_qd256]
stonewall
bs=4k							# 4k block transfer size
ba=4k							# All IO's 4k aligned
iodepth=64
numjobs=4
rw=randwrite
size=100%
randrepeat=0 
norandommap 
refill_buffers
log_avg_msec=1000
unified_rw_reporting=1
write_bw_log=4k-4k_randwrite_0_rd_qd32
write_iops_log=4k-4k_randwrite_0_rd_qd32
write_lat_log=4k-4k_randwrite_0_rd_qd32

If someone could tell me what I am missing, it would be great!!


Thanks,
Prabhakaran Murugesan
