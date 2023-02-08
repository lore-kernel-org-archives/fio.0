Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0106C05027
	for <fio@archiver.kernel.org>; Wed,  8 Feb 2023 23:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBHXSc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 18:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBHXSb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 18:18:31 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E358826B7
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 15:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675898308; x=1707434308;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p4xXQOqEuycY99VVEqvjeowMulCIZACdbw0iedCgFAA=;
  b=PgmfDNCBePQ7+F7DIxVuZ3wVh2vgZlPmF+eRByjuRptGenac8b9ysVaM
   sHZnnYOLcgWpuiaeMsiAL3usHxb7jAFr/CWgxJSnsfTM1blFKYyNTX42g
   l3a0cmJ/iWIJ8Fp3Xi7D3OsJM7FEGNx6xewM4mBu0NUgKuOuMfuXxwgnN
   VAR2+RigW88jUe5gvMVzRlOOqdT3OxLs1X5Tt5/HMmfisMLz0K+A4Xvlh
   sq3TTPT2kVlQZwLGYjI2VW+0AMgyI8lQAb+1JlDR2KdNBkby4VoGArPHS
   n+vUkvDdlwGZY4VpWxFUMT5UsLvO+A1PKRwUUfmo0xV+6qi6m/demAP9P
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="221163593"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 07:18:28 +0800
IronPort-SDR: npPxFpgL9kjyyn5e4lJmNU+gNaoXngSykrgnN3NCg+snhcbVcj4PYx/Dx2kUD/34QsctcvYcl8
 cnq0fM2xptyq6m//cGvabej3E2lisH9LmpPKbhscT4aqDzbMAlgmDP5ZmipmnamNrwLS7Iag3f
 /5GUzpuEDXXUkKip0pDZwk7PmDCfEs9Bx9tgyR22vREjYmp0r5/apvYXCG0cL63iCtRkwA8NGW
 LRY06onP8OTXoNvYrjTZYOvqflQI5S7f4VlzCYUmfx/iCH2q/dVtG87S/8Ouke5Tbh7Vreq5zL
 P/0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 14:29:58 -0800
IronPort-SDR: MYkCwZqDHcL+oapAFN4W3RjoWCUHe0gWsJYKJhuBHGk32s7wp5BOa+HLCCWaGAWayOICPa4to7
 CdWvWvADO6XXmA+hJy3BJXXy56WVaH/TaStS5zlYjumUP+oS/1DjYOvtlqHF6G446cBgdFd8Kz
 8pv8JPwTmqngGb8dXV0zU64p8Qrj0QN5gY2PDd+ZPa4slgr/mRaytxUNrejowxI0X4mupceo70
 Xtki0eCdzLSs08hdU6vF/ncZLa173sTPJZIe7EJxOYW5TUcM1vUTDywXoRf+HqUPYzUcxguRH2
 y4w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 15:18:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PBwsb6zyqz1RwqL
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 15:18:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1675898306; x=1678490307; bh=p4xXQOqEuycY99VVEqvjeowMulCIZACdbw0
        iedCgFAA=; b=HHLd1voqTLskbZaxeWJrVQl0m/Az+UAsurZyELqE0HTHNhyh8vu
        PwWVjNL3wyDjOTxtimIBhN8FQId1QDJ8qDafCEd/LZ4UuG/3vPniurdcQJmXEQof
        FFx++SBxtizqKEG+OCzv6u6QO4QHwY6hzLWvhSHD3o2zgpysdBcoddWWhV3vz/FR
        +w2XY4mptE7XWAG4Xl/hsd9YTYmgy4tFrfPQdjDhwefvhe+RNyhaHv/Z7KXXQIiA
        EGNDco5q0Ki9tgKDQSRNfMQLyqAu5Vieu7xH9NY4zXVGMMwMfR7ceEICJGnumZpd
        BPz+0CvsTfk7R2jlOYqW/P58S8ryi715idQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QBGslNOa7EHq for <fio@vger.kernel.org>;
        Wed,  8 Feb 2023 15:18:26 -0800 (PST)
Received: from [10.225.163.102] (unknown [10.225.163.102])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PBwsX6l3lz1RvLy;
        Wed,  8 Feb 2023 15:18:24 -0800 (PST)
Message-ID: <81ec3a3c-73a5-b451-fbf7-b541ec6e0b28@opensource.wdc.com>
Date:   Thu, 9 Feb 2023 08:18:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230208222023.895024-1-kbusch@meta.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230208222023.895024-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/9/23 07:20, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> NVMe TP4146 creates a new feature called Flexible Data Placement. This
> feature allows a host to tell the device how to group write data through
> the use of "Placement Identifiers" in write commands.
> 
> Add support for using placement identifiers in write commands. The user
> can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
> ioengine. By default, the fio jobs will cycle through all the namespace's
> available placement identifiers for write commands. The user can limit
> which placement identifiers can be used with additional parameter,
> "fdp_plis=<list,>", which can be used to separate write intensive jobs
> from less intenstive ones.

s/intenstive/intensive

> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  Makefile                   |   2 +-
>  engines/io_uring.c         |  31 ++++++++
>  engines/nvme.c             |  88 +++++++++++++++++++++-
>  engines/nvme.h             | 148 +++++++++++++++++++++++++++++++++++++
>  examples/uring-cmd-fdp.fio |  37 ++++++++++
>  file.h                     |   3 +
>  filesetup.c                |   7 ++
>  io_u.c                     |   3 +
>  io_u.h                     |   3 +
>  ioengines.h                |   4 +
>  options.c                  |  49 ++++++++++++
>  thread_options.h           |   8 ++
>  12 files changed, 381 insertions(+), 2 deletions(-)
>  create mode 100644 examples/uring-cmd-fdp.fio
> 
> diff --git a/Makefile b/Makefile
> index 5f4e6562..89205ebf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -62,7 +62,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
>  		gettime-thread.c helpers.c json.c idletime.c td_error.c \
>  		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
>  		workqueue.c rate-submit.c optgroup.c helper_thread.c \
> -		steadystate.c zone-dist.c zbd.c dedupe.c
> +		steadystate.c zone-dist.c zbd.c dedupe.c fdp.c
>  
>  ifdef CONFIG_LIBHDFS
>    HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index a9abd11d..644b279f 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -1262,6 +1262,34 @@ static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
>  	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
>  }
>  
> +static int fio_ioring_cmd_fdp_support(struct thread_data *td, struct fio_file *f,
> +                                  bool *support)
> +{
> +	return fio_nvme_is_fdp(td, f, support);
> +}
> +
> +static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
> +                                 struct fio_ruhs_info *fruhs_info)
> +{
> +	struct nvme_fdp_ruh_status *ruhs;
> +	int bytes, ret, i;
> +
> +	bytes = sizeof(*ruhs) + 1024 * sizeof(struct nvme_fdp_ruh_status_desc);
> +	ruhs = malloc(bytes);
> +	memset(ruhs, 0, bytes);
> +
> +	ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
> +	if (ret)
> +		goto free;
> +
> +        fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
> +        for (i = 0; i < fruhs_info->nr_ruhs; i++)
> +                fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
> +free:
> +	free(ruhs);
> +	return ret;
> +}
> +
>  static struct ioengine_ops ioengine_uring = {
>  	.name			= "io_uring",
>  	.version		= FIO_IOOPS_VERSION,
> @@ -1307,6 +1335,9 @@ static struct ioengine_ops ioengine_uring_cmd = {
>  	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
>  	.options		= options,
>  	.option_struct_size	= sizeof(struct ioring_options),
> +
> +        .fdp_support		= fio_ioring_cmd_fdp_support,
> +        .fetch_ruhs		= fio_ioring_cmd_fetch_ruhs,
>  };
>  
>  static void fio_init fio_ioring_register(void)
> diff --git a/engines/nvme.c b/engines/nvme.c
> index 9ffc5303..af4be733 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -28,7 +28,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>  	cmd->cdw10 = slba & 0xffffffff;
>  	cmd->cdw11 = slba >> 32;
>  	/* cdw12 represent number of lba's for read/write */
> -	cmd->cdw12 = nlb;
> +	cmd->cdw12 = nlb | (io_u->dtype << 20);
> +	cmd->cdw13 = io_u->dspec << 16;
>  	if (iov) {
>  		iov->iov_base = io_u->xfer_buf;
>  		iov->iov_len = io_u->xfer_buflen;
> @@ -345,3 +346,88 @@ out:
>  	close(fd);
>  	return ret;
>  }
> +
> +static inline int nvme_dir_id(int fd, __u32 nsid, struct nvme_id_directives *data)
> +{
> +	__u32 data_len = sizeof(*data);
> +
> +        struct nvme_passthru_cmd cmd = {
> +		.opcode         = nvme_admin_directive_recv,
> +		.nsid           = nsid,
> +		.cdw10          = (data_len >> 2) - 1,
> +		.cdw11          = 1,
> +		.data_len       = data_len,
> +		.addr           = (__u64)(uintptr_t)data,
> +        };
> +
> +	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
> +}
> +
> +int fio_nvme_is_fdp(struct thread_data *td, struct fio_file *f, bool *fdp)
> +{
> +	struct nvme_data *data = FILE_ENG_DATA(f);
> +	struct nvme_id_directives dir;
> +	struct nvme_id_ctrl id;
> +	bool is_fdp = false;
> +	int fd, ret = 0;
> +
> +	*fdp = false;
> +	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CTRL, 0, &id);
> +	if (ret) {
> +		log_err("%s: nvme_id_ctrl failed, err=%d\n",
> +			f->file_name, ret);
> +		goto out;
> +	}
> +
> +	is_fdp = le32_to_cpu(id.ctratt) & (1 << 19);
> +	if (!is_fdp)
> +		goto out;
> +
> +	ret = nvme_dir_id(fd, data->nsid, &dir);
> +	if (ret) {
> +		log_err("%s: nvme_dir_id failed, err=%d\n",
> +			f->file_name, ret);
> +		is_fdp = false;
> +		goto out;
> +	}
> +
> +	is_fdp = dir.enabled[0] & (1 << 2);
> +out:
> +	*fdp = is_fdp;
> +	close(fd);
> +	return ret;
> +}
> +
> +static inline int nvme_fdp_reclaim_unit_handle_status(int fd, __u32 nsid,
> +                        __u32 data_len, void *data)
> +{
> +	struct nvme_passthru_cmd cmd = {
> +		.opcode		= nvme_cmd_io_mgmt_recv,
> +		.nsid		= nsid,
> +		.addr		= (__u64)(uintptr_t)data,
> +		.data_len 	= data_len,
> +		.cdw10		= 1,
> +		.cdw11          = (data_len >> 2) - 1,
> +	};
> +
> +	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
> +}
> +
> +int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
> +			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes)
> +{
> +	struct nvme_data *data = FILE_ENG_DATA(f);
> +	int fd, ret = 0;
> +
> +	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = nvme_fdp_reclaim_unit_handle_status(fd, data->nsid, bytes, ruhs);
> +	close(fd);
> +	return ret;
> +}
> diff --git a/engines/nvme.h b/engines/nvme.h
> index 70a89b74..574f16d8 100644
> --- a/engines/nvme.h
> +++ b/engines/nvme.h
> @@ -50,6 +50,7 @@ struct nvme_uring_cmd {
>  
>  enum nvme_identify_cns {
>  	NVME_IDENTIFY_CNS_NS		= 0x00,
> +	NVME_IDENTIFY_CNS_CTRL		= 0x01,
>  	NVME_IDENTIFY_CNS_CSI_NS	= 0x05,
>  	NVME_IDENTIFY_CNS_CSI_CTRL	= 0x06,
>  };
> @@ -62,11 +63,13 @@ enum nvme_csi {
>  
>  enum nvme_admin_opcode {
>  	nvme_admin_identify		= 0x06,
> +	nvme_admin_directive_recv	= 0x1a,
>  };
>  
>  enum nvme_io_opcode {
>  	nvme_cmd_write			= 0x01,
>  	nvme_cmd_read			= 0x02,
> +	nvme_cmd_io_mgmt_recv		= 0x12,
>  	nvme_zns_cmd_mgmt_send		= 0x79,
>  	nvme_zns_cmd_mgmt_recv		= 0x7a,
>  };
> @@ -86,6 +89,126 @@ struct nvme_data {
>  	__u32 lba_shift;
>  };
>  
> +struct nvme_id_psd {
> +	__le16			mp;
> +	__u8			rsvd2;
> +	__u8			flags;
> +	__le32                  enlat;
> +	__le32                  exlat;
> +	__u8			rrt;
> +	__u8			rrl;
> +	__u8			rwt;
> +	__u8			rwl;
> +	__le16			idlp;
> +	__u8			ips;
> +	__u8			rsvd19;
> +	__le16			actp;
> +	__u8			apws;
> +	__u8			rsvd23[9];
> +};
> +
> +struct nvme_id_ctrl {
> +	__le16			vid;
> +	__le16			ssvid;
> +	char			sn[20];
> +	char			mn[40];
> +	char			fr[8];
> +	__u8			rab;
> +	__u8			ieee[3];
> +	__u8			cmic;
> +	__u8			mdts;
> +	__le16			cntlid;
> +	__le32			ver;
> +	__le32			rtd3r;
> +	__le32			rtd3e;
> +	__le32			oaes;
> +	__le32			ctratt;
> +	__le16			rrls;
> +	__u8			rsvd102[9];
> +	__u8			cntrltype;
> +	__u8			fguid[16];
> +	__le16			crdt1;
> +	__le16			crdt2;
> +	__le16			crdt3;
> +	__u8			rsvd134[119];
> +	__u8			nvmsr;
> +	__u8			vwci;
> +	__u8			mec;
> +	__le16			oacs;
> +	__u8			acl;
> +	__u8			aerl;
> +	__u8			frmw;
> +	__u8			lpa;
> +	__u8			elpe;
> +	__u8			npss;
> +	__u8			avscc;
> +	__u8			apsta;
> +	__le16			wctemp;
> +	__le16			cctemp;
> +	__le16			mtfa;
> +	__le32			hmpre;
> +	__le32			hmmin;
> +	__u8			tnvmcap[16];
> +	__u8			unvmcap[16];
> +	__le32			rpmbs;
> +	__le16			edstt;
> +	__u8			dsto;
> +	__u8			fwug;
> +	__le16			kas;
> +	__le16			hctma;
> +	__le16			mntmt;
> +	__le16			mxtmt;
> +	__le32			sanicap;
> +	__le32			hmminds;
> +	__le16			hmmaxd;
> +	__le16			nsetidmax;
> +	__le16			endgidmax;
> +	__u8			anatt;
> +	__u8			anacap;
> +	__le32			anagrpmax;
> +	__le32			nanagrpid;
> +	__le32			pels;
> +	__le16			domainid;
> +	__u8			rsvd358[10];
> +	__u8			megcap[16];
> +	__u8			rsvd384[128];
> +	__u8			sqes;
> +	__u8			cqes;
> +	__le16			maxcmd;
> +	__le32			nn;
> +	__le16			oncs;
> +	__le16			fuses;
> +	__u8			fna;
> +	__u8			vwc;
> +	__le16			awun;
> +	__le16			awupf;
> +	__u8			icsvscc;
> +	__u8			nwpc;
> +	__le16			acwu;
> +	__le16			ocfs;
> +	__le32			sgls;
> +	__le32			mnan;
> +	__u8			maxdna[16];
> +	__le32			maxcna;
> +	__u8			rsvd564[204];
> +	char			subnqn[256];
> +	__u8			rsvd1024[768];
> +
> +	/* Fabrics Only */
> +	__le32			ioccsz;
> +	__le32			iorcsz;
> +	__le16			icdoff;
> +	__u8			fcatt;
> +	__u8			msdbd;
> +	__le16			ofcs;
> +	__u8			dctype;
> +	__u8			rsvd1807[241];
> +
> +	struct nvme_id_psd	psd[32];
> +	__u8			vs[1024];
> +};
> +
> +
>  struct nvme_lbaf {
>  	__le16			ms;
>  	__u8			ds;
> @@ -192,6 +315,31 @@ struct nvme_zone_report {
>  	struct nvme_zns_desc	entries[];
>  };
>  
> +struct nvme_id_directives {
> +	__u8	supported[32];
> +	__u8	enabled[32];
> +	__u8	rsvd64[4032];
> +};
> +
> +struct nvme_fdp_ruh_status_desc {
> +        __u16 pid;
> +        __u16 ruhid;
> +        __u32 earutr;
> +        __u64 ruamw;
> +        __u8  rsvd16[16];
> +};
> +
> +struct nvme_fdp_ruh_status {
> +        __u8  rsvd0[14];
> +        __le16 nruhsd;
> +        struct nvme_fdp_ruh_status_desc ruhss[];
> +};
> +
> +int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
> +			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
> +
> +int fio_nvme_is_fdp(struct thread_data *td, struct fio_file *f, bool *fdp);
> +
>  int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
>  		      __u64 *nlba);
>  
> diff --git a/examples/uring-cmd-fdp.fio b/examples/uring-cmd-fdp.fio
> new file mode 100644
> index 00000000..55d741d3
> --- /dev/null
> +++ b/examples/uring-cmd-fdp.fio
> @@ -0,0 +1,37 @@
> +# io_uring_cmd I/O engine for nvme-ns generic character device with FDP enabled
> +# This assumes the namespace is already configured with FDP support and has at
> +# least 8 available reclaim units.
> +#
> +# Each job targets different ranges of LBAs with different placement
> +# identifiers, and has different write intensity.
> +
> +[global]
> +filename=/dev/ng0n1
> +ioengine=io_uring_cmd
> +cmd_type=nvme
> +iodepth=32
> +bs=4K
> +fdp=1
> +time_based=1
> +runtime=1000
> +
> +[write-heavy]
> +rw=randrw
> +rwmixwrite=90
> +fdp_pli=0,1,2,3
> +offset=0%
> +size=30%
> +
> +[write-mid]
> +rw=randrw
> +rwmixwrite=30
> +fdp_pli=4,5
> +offset=30%
> +size=30%
> +
> +[write-light]
> +rw=randrw
> +rwmixwrite=10
> +fdp_pli=6
> +offset=60%
> +size=30%
> diff --git a/file.h b/file.h
> index da1b8947..deb36e02 100644
> --- a/file.h
> +++ b/file.h
> @@ -12,6 +12,7 @@
>  
>  /* Forward declarations */
>  struct zoned_block_device_info;
> +struct fdp_ruh_info;
>  
>  /*
>   * The type of object we are working on
> @@ -101,6 +102,8 @@ struct fio_file {
>  	uint64_t file_offset;
>  	uint64_t io_size;
>  
> +	struct fio_ruhs_info *ruhs_info;
> +
>  	/*
>  	 * Zoned block device information. See also zonemode=zbd.
>  	 */
> diff --git a/filesetup.c b/filesetup.c
> index cb7047c5..c1f38858 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1417,6 +1417,12 @@ done:
>  
>  	td_restore_runstate(td, old_state);
>  
> +	if (td->o.fdp) {
> +		err = fdp_init(td);
> +		if (err)
> +			goto err_out;
> +	}
> +
>  	return 0;
>  
>  err_offset:
> @@ -1627,6 +1633,7 @@ void close_and_free_files(struct thread_data *td)
>  		}
>  
>  		zbd_close_file(f);
> +		fdp_free_ruhs_info(f);
>  		fio_file_free(f);
>  	}
>  
> diff --git a/io_u.c b/io_u.c
> index 8035f4b7..60be4f01 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -980,6 +980,9 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
>  			return 1;
>  	}
>  
> +	if (td->o.fdp)
> +		fdp_fill_dspec_data(td, io_u);
> +
>  	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
>  		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
>  			io_u,
> diff --git a/io_u.h b/io_u.h
> index 206e24fe..13b26d37 100644
> --- a/io_u.h
> +++ b/io_u.h
> @@ -117,6 +117,9 @@ struct io_u {
>  	 */
>  	int (*end_io)(struct thread_data *, struct io_u **);
>  
> +	uint32_t dtype;
> +	uint32_t dspec;
> +
>  	union {
>  #ifdef CONFIG_LIBAIO
>  		struct iocb iocb;
> diff --git a/ioengines.h b/ioengines.h
> index 2cb9743e..4a9284c0 100644
> --- a/ioengines.h
> +++ b/ioengines.h
> @@ -7,6 +7,7 @@
>  #include "flist.h"
>  #include "io_u.h"
>  #include "zbd_types.h"
> +#include "fdp.h"
>  
>  #define FIO_IOOPS_VERSION	31
>  
> @@ -63,6 +64,9 @@ struct ioengine_ops {
>  				  unsigned int *);
>  	int (*finish_zone)(struct thread_data *, struct fio_file *,
>  			   uint64_t, uint64_t);
> +        int (*fdp_support)(struct thread_data *, struct fio_file *, bool *);
> +        int (*fetch_ruhs)(struct thread_data *, struct fio_file *,
> +                          struct fio_ruhs_info *);
>  	int option_struct_size;
>  	struct fio_option *options;
>  };
> diff --git a/options.c b/options.c
> index 49612345..3e6dc3c6 100644
> --- a/options.c
> +++ b/options.c
> @@ -251,6 +251,34 @@ int str_split_parse(struct thread_data *td, char *str,
>  	return ret;
>  }
>  
> +static int fio_fdp_cmp(const void *p1, const void *p2)
> +{
> +	const uint16_t *t1 = p1;
> +	const uint16_t *t2 = p2;
> +
> +	return *t1 - *t2;
> +}
> +
> +static int str_fdp_pli_cb(void *data, const char *input)
> +{
> +	struct thread_data *td = cb_data_to_td(data);
> +	char *str, *p, *v;
> +	int i = 0;
> +
> +	p = str = strdup(input);
> +	strip_blank_front(&str);
> +	strip_blank_end(str);
> +
> +	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_PLIS)
> +		td->o.plis[i++] = strtoll(v, NULL, 0);
> +	free(p);
> +
> +	td->o.nrpli = i;
> +	qsort(td->o.plis, td->o.nrpli, sizeof(*td->o.plis), fio_fdp_cmp);
> +
> +	return 0;
> +}
> +
>  static int str_bssplit_cb(void *data, const char *input)
>  {
>  	struct thread_data *td = cb_data_to_td(data);
> @@ -3649,6 +3677,27 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>  		.category = FIO_OPT_C_IO,
>  		.group	= FIO_OPT_G_ZONE,
>  	},
> +	{
> +		.name   = "fdp",
> +		.lname  = "Flexible data placement",
> +		.type   = FIO_OPT_BOOL,
> +		.off1   = offsetof(struct thread_options, fdp),
> +		.help   = "Use Data placement directive (FDP)",
> +		.def    = "0",
> +		.category = FIO_OPT_C_IO,
> +		.group  = FIO_OPT_G_INVALID,
> +	},
> +	{
> +		.name	= "fdp_pli",
> +		.lname	= "FDP Placement ID indicies",
> +		.type	= FIO_OPT_STR,
> +		.cb	= str_fdp_pli_cb,
> +		.off1	= offsetof(struct thread_options, plis),
> +		.help	= "Sets which placement ids to use (defaults to all)",
> +		.hide	= 1,
> +		.category = FIO_OPT_C_IO,
> +		.group	= FIO_OPT_G_INVALID,
> +	},
>  	{
>  		.name	= "lockmem",
>  		.lname	= "Lock memory",
> diff --git a/thread_options.h b/thread_options.h
> index 74e7ea45..34eb4d3f 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -386,6 +386,12 @@ struct thread_options {
>  	fio_fp64_t zrt;
>  	fio_fp64_t zrf;
>  
> +	unsigned int fdp;
> +
> +#define FIO_MAX_PLIS 16
> +	unsigned int plis[FIO_MAX_PLIS];
> +	unsigned int nrpli;
> +
>  	unsigned int log_entries;
>  	unsigned int log_prio;
>  };
> @@ -698,6 +704,8 @@ struct thread_options_pack {
>  	uint32_t log_entries;
>  	uint32_t log_prio;
>  
> +	uint32_t fdp;
> +
>  	/*
>  	 * verify_pattern followed by buffer_pattern from the unpacked struct
>  	 */

-- 
Damien Le Moal
Western Digital Research

