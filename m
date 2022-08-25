Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13793C04AA5
	for <fio@archiver.kernel.org>; Thu, 25 Aug 2022 12:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiHYMCJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Aug 2022 08:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiHYMCH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Aug 2022 08:02:07 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A369A80F60
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 05:02:05 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220825120200epoutp0326315041baa13a5b51d632e2d7892c77~OlMzh9hjE0476404764epoutp03g
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 12:02:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220825120200epoutp0326315041baa13a5b51d632e2d7892c77~OlMzh9hjE0476404764epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661428920;
        bh=ChytRc64AXtC/+8iDz8N5LCF9wko8aV/+SMsSSpP7Tw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=olzI8p1m0wDAJURU+U8FV1E/Z0rqRhr5qufSO2eeAqgLj8zMCY6Rgwf5tp6ui5oNm
         FtiGTh93n1cBHzIIiEbIfV940ZEVQuPl5ASwzl8AOwRvfWH29X+EDLn1H68hhXLKXI
         H8ost8kjA7ulbzcXWlYWByQ4XMLSSoCoIctP06l8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220825120159epcas5p4376807011bffec6ec987a27ec2f6b1c9~OlMzRQBQm0922209222epcas5p4b;
        Thu, 25 Aug 2022 12:01:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MD1m571Vvz4x9Q6; Thu, 25 Aug
        2022 12:01:57 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.FA.59633.4B467036; Thu, 25 Aug 2022 21:01:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220825114934epcas5p2cd6c07cf996e2538192a0f2faf64061e~OlB9ZWcIC1327213272epcas5p2Z;
        Thu, 25 Aug 2022 11:49:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220825114934epsmtrp178eb85921d52992d2995aa71a0c0fb82~OlB9Yq3b_1712517125epsmtrp11;
        Thu, 25 Aug 2022 11:49:34 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-5d-630764b4e5be
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.7A.14392.EC167036; Thu, 25 Aug 2022 20:49:34 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220825114933epsmtip1af4b9b6c1436d702c1419ce00e93cddf~OlB8bU9gR1982119821epsmtip1B;
        Thu, 25 Aug 2022 11:49:33 +0000 (GMT)
Date:   Thu, 25 Aug 2022 17:09:52 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, vincentfu@gmail.com, ankit.kumar@samsung.com,
        fio@vger.kernel.org
Subject: Re: [PATCH 2/2] t/io_uring: add support for async-passthru
Message-ID: <20220825113952.GB16653@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220825082444.GB22496@test-zns>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTQ3dLCnuywdeVhhZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUz
        L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKuSQlliTilQKCCxuFhJ386mKL+0
        JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj2+1HjAV37St2f93C2sD4
        SbeLkZNDQsBE4uTZa8xdjFwcQgK7GSWOdaxhhXA+MUose/iHCaRKSOAbo8TL5VVdjBxgHWen
        WULU7GWUeL38NguE84xRYnbHNbAGFgFViWOzuxlBbDYBdYkjz1vBbBEgu2P6ObAaZoEIifOb
        IGqEBZwlpjRA2LwCuhIH7l9ghrAFJU7OfMICYnMK6EnMa/oN1isqoCxxYNtxJpDFEgL32CVW
        bTvHCHGdi8SSmVUQrwlLvDq+hR3ClpJ42d8GZadL/Lj8lAnCLpBoPraPEcK2l2g91c8McVuG
        xMfVq6HishJTT62DuplPovf3E6heXokd82BsJYn2lXOgbAmJvecaoGwPifWbNkID6DGjxJZb
        69gmMMrPQvLbLCT7IGwdiQW7P7HNAnqHWUBaYvk/DghTU2L9Lv0FjKyrGCVTC4pz01OLTQsM
        81LL4fGdnJ+7iRGcJrU8dzDeffBB7xAjEwfjIUYJDmYlEV6rYyzJQrwpiZVVqUX58UWlOanF
        hxhNgXE1kVlKNDkfmKjzSuINTSwNTMzMzEwsjc0MlcR5p2gzJgsJpCeWpGanphakFsH0MXFw
        SjUwMb6cbcqxvDckMURMVMFiRuT6xoxkF6cWc6WSVjYXtgNxfbEvb152tcw5XS6ruilx043m
        ltcJCX4LmL1vVzUEeM8vzz53+9H8p79d3G3fcLXOmeFiuEEtICNOb9FkqfgLYid4q7Ze130V
        qP0/6uVpmRsv51049zm5x0N1R8iv2nddKyqO224Q0s1UNff/yOu+mUvIyaRh9oSvCque8qz0
        v5B3O7UtcnGpgcT9HcV3xCYca3+ZvvTrh5MXVn+341G4+iuworhuzcNVl080iVwp1T6+7qPZ
        zwXNJx6t+eBk5/fm2bVC/s0Slm7v8kpvH1zW8d5gkZBs1bHg9kXnf59/ekbtidyKGaWME43d
        IkVNlFiKMxINtZiLihMBRSi4URwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnO65RPZkg0cPDCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2axoU3QgdVj56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b7
        6yuYCubaVsxdeoGtgfG0dhcjB4eEgInE2WmWXYxcHEICuxklPh2ZydrFyAkUl5A49XIZI4Qt
        LLHy33N2EFtI4AmjRPNZFxCbRUBV4tjsbrAaNgF1iSPPW8FsESC7Y/o5JhCbWSBC4vwmiBph
        AWeJKQ0QNq+ArsSB+xeYIRY/ZpQ4c38TM0RCUOLkzCcsEM1aEjf+vWQCOZRZQFpi+T8OkDCn
        gJ7EvKbfYPNFBZQlDmw7zjSBUXAWku5ZSLpnIXQvYGRexSiZWlCcm55bbFhgmJdarlecmFtc
        mpeul5yfu4kRHN5amjsYt6/6oHeIkYmD8RCjBAezkgiv1TGWZCHelMTKqtSi/Pii0pzU4kOM
        0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYRKT+Bj65siPkfVK+0GR33d35nZ8e7FuV
        Om/tUR/bramy209+nP9xwtmjh12WZPzIUIs6lbljnv28ldMdvi0wbpE4lD3v5vuLcRYGjfFv
        OdmjGOJW8p5q1/p2bvaVGydVLpdqbLif8uNL1qwrD6JfrD976rPJfmYlr23XlLRkrr32FFU0
        P7vIeqGST9QN1zWdwbb5sfFqh1tNjTI+nlbvl79ewLY1OffiileO6Tym95n36bhYB9RMvme6
        5kIGU+zMS1fnLmPp6ejkTD3R3uU7z1DUPkpoXsaD89WJ+7KmishVzOBwTUl8fDD2Z8RdPc+t
        Pixf76VezHXOZig5b1J8Pd9wYYnPwk8zrCYp1Xw8ocRSnJFoqMVcVJwIAGBLCj7eAgAA
X-CMS-MailID: 20220825114934epcas5p2cd6c07cf996e2538192a0f2faf64061e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa62a_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712
References: <20220824093109.308791-1-anuj20.g@samsung.com>
        <CGME20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712@epcas5p4.samsung.com>
        <20220824093109.308791-3-anuj20.g@samsung.com>
        <20220825082444.GB22496@test-zns>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa62a_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Aug 25, 2022 at 01:54:44PM +0530, Kanchan Joshi wrote:
> On Wed, Aug 24, 2022 at 03:01:09PM +0530, Anuj Gupta wrote:
> > This patch adds support for async-passthru in t/io_uring. User needs to
> > specify -u1 option in the command
> > 
> > Example commandline:
> > t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
> > 
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> > t/io_uring.c | 146 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > 1 file changed, 138 insertions(+), 8 deletions(-)
> > 
> > diff --git a/t/io_uring.c b/t/io_uring.c
> > index a42abd46..78fedaf1 100644
> > --- a/t/io_uring.c
> > +++ b/t/io_uring.c
> > @@ -35,6 +35,7 @@
> > #include "../lib/rand.h"
> > #include "../minmax.h"
> > #include "../os/linux/io_uring.h"
> > +#include "../engines/nvme.h"
> > 
> > struct io_sq_ring {
> > 	unsigned *head;
> > @@ -139,6 +140,9 @@ static int random_io = 1;	/* random or sequential IO */
> > static int register_ring = 1;	/* register ring */
> > static int use_sync = 0;	/* use preadv2 */
> > static int numa_placement = 0;	/* set to node of device */
> > +static int pt = 0;		/* passthrough I/O or not */
> > +static unsigned int nsid = 0;	/* nsid field required for nvme-passthrough */
> > +static unsigned int lbs = 0;	/* logical_block_size field required for nvme-passthrough */
> > 
> > static unsigned long tsc_rate;
> > 
> > @@ -161,6 +165,54 @@ struct io_uring_map_buffers {
> > };
> > #endif
> > 
> > +static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
> > +			 enum nvme_csi csi, void *data)
> > +{
> > +	struct nvme_passthru_cmd cmd = {
> > +		.opcode         = nvme_admin_identify,
> > +		.nsid           = nsid,
> > +		.addr           = (__u64)(uintptr_t)data,
> > +		.data_len       = NVME_IDENTIFY_DATA_SIZE,
> > +		.cdw10          = cns,
> > +		.cdw11          = csi << NVME_IDENTIFY_CSI_SHIFT,
> > +		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
> > +	};
> > +
> > +	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
> > +}
> > +
> > +static int nvme_get_info(int fd, __u32 *nsid, __u32 *lba_sz, __u64 *nlba)
> > +{
> > +	struct nvme_id_ns ns;
> > +	int namespace_id;
> > +	int err;
> > +
> > +	namespace_id = ioctl(fd, NVME_IOCTL_ID);
> > +	if (namespace_id < 0) {
> > +		fprintf(stderr, "error failed to fetch namespace-id\n");
> > +		close(fd);
> > +		return -errno;
> > +	}
> > +
> > +	/*
> > +	 * Identify namespace to get namespace-id, namespace size in LBA's
> > +	 * and LBA data size.
> > +	 */
> > +	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
> > +				NVME_CSI_NVM, &ns);
> > +	if (err) {
> > +		fprintf(stderr, "error failed to fetch identify namespace\n");
> > +		close(fd);
> > +		return err;
> > +	}
> > +
> > +	*nsid = namespace_id;
> > +	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
> > +	*nlba = ns.nsze;
> > +
> > +	return 0;
> > +}
> > +
> > static unsigned long cycles_to_nsec(unsigned long cycles)
> > {
> > 	uint64_t val;
> > @@ -457,12 +509,13 @@ static unsigned file_depth(struct submitter *s)
> > 
> > static void init_io(struct submitter *s, unsigned index)
> > {
> > -	struct io_uring_sqe *sqe = &s->sqes[index];
> > +	struct io_uring_sqe *sqe = NULL;
> > 	unsigned long offset;
> > 	struct file *f;
> > 	long r;
> > 
> > 	if (do_nop) {
> > +		sqe = &s->sqes[index];
> 
> Nit: this and previous change is not must as <see below>
> 

got it, will change this

> > 		sqe->opcode = IORING_OP_NOP;
> > 		return;
> > 	}
> > @@ -490,6 +543,41 @@ static void init_io(struct submitter *s, unsigned index)
> > 			f->cur_off = 0;
> > 	}
> > 
> > +	if (pt) {
> > +		struct nvme_uring_cmd *cmd;
> > +		unsigned long long slba;
> > +		unsigned long long nlb;
> > +
> > +		sqe = &s->sqes[index<<1];
> 
> this is enough.
> 
> > +		if (register_files) {
> > +			sqe->fd = f->fixed_fd;
> > +			sqe->flags = IOSQE_FIXED_FILE;
> > +		} else {
> > +			sqe->fd = f->real_fd;
> > +			sqe->flags = 0;
> > +		}
> > +		sqe->opcode = IORING_OP_URING_CMD;
> > +		sqe->user_data = (unsigned long) f->fileno;
> > +		if (stats)
> > +			sqe->user_data |= ((unsigned long)s->clock_index << 32);
> > +		sqe->cmd_op = NVME_URING_CMD_IO;
> > +		slba = offset / lbs;
> > +		nlb = bs/lbs - 1;
> > +		cmd = (struct nvme_uring_cmd *)&sqe->cmd;
> > +		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> > +		/* cdw10 and cdw11 represent starting slba*/
> > +		cmd->cdw10 = slba & 0xffffffff;
> > +		cmd->cdw11 = slba >> 32;
> > +		/* cdw12 represent number of lba to be read*/
> > +		cmd->cdw12 = nlb;
> > +		cmd->addr = (unsigned long) s->iovecs[index].iov_base;
> > +		cmd->data_len = bs;
> > +		cmd->nsid = nsid;
> > +		cmd->opcode = 2;
> > +		return;
> > +	}
> > +
> > +	sqe = &s->sqes[index];
> > 	if (register_files) {
> > 		sqe->flags = IOSQE_FIXED_FILE;
> > 		sqe->fd = f->fixed_fd;
> > @@ -549,7 +637,22 @@ static int get_file_size(struct file *f)
> > 
> > 	if (fstat(f->real_fd, &st) < 0)
> > 		return -1;
> > -	if (S_ISBLK(st.st_mode)) {
> > +	if (pt) {
> > +		__u64 nlba;
> > +		int ret;
> > +
> > +		if (!S_ISCHR(st.st_mode)) {
> > +			fprintf(stderr, "passthrough works with only nvme-ns "
> > +					"generic devices (/dev/ngXnY)\n");
> > +			return -1;
> > +		}
> > +		ret = nvme_get_info(f->real_fd, &nsid, &lbs, &nlba);
> > +		if (ret)
> > +			return -1;
> > +		f->max_blocks = nlba / bs;
> > +		f->max_size = nlba;
> > +		return 0;
> > +	} else if (S_ISBLK(st.st_mode)) {
> > 		unsigned long long bytes;
> > 
> > 		if (ioctl(f->real_fd, BLKGETSIZE64, &bytes) != 0)
> > @@ -587,11 +690,14 @@ static int reap_events_uring(struct submitter *s)
> > 
> > 			f = &s->files[fileno];
> > 			f->pending_ios--;
> > -			if (cqe->res != bs) {
> > +			if (!pt && cqe->res != bs) {
> > 				printf("io: unexpected ret=%d\n", cqe->res);
> > 				if (polled && cqe->res == -EOPNOTSUPP)
> > 					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
> > 				return -1;
> > +			} else if (pt && cqe->res != 0) {
> > +				printf("io: unexpected ret=%d\n", cqe->res);
> > +				return -1;
> 
> Missing inner check (polled one) for pt case?

right, adding a check for polling makes sense.

> How about something like this fragement -
> 
>                if (!do_nop) {
>                        int fileno = cqe->user_data & 0xffffffff;
> +                       bool error;
> 
>                        f = &s->files[fileno];
>                        f->pending_ios--;
> -                       if (!pt && cqe->res != bs) {
> +                       if (!pt)
> +                               error = (cqe->res != bs);
> +                       else
> +                               error = (cqe->res != 0);
> +                       if (error) {
>                                printf("io: unexpected ret=%d\n", cqe->res);
>                                if (polled && cqe->res == -EOPNOTSUPP)
>                                        printf("Your filesystem/driver/kernel doesn't support polled IO\n");
>                                return -1;
> 
> [...]
>

I think, the result is -EINVAL rather than -EOPNOTSUPP, if the user enables polling for passthru i/o.
With that we can check for polled-io for passthru

> > @@ -1512,6 +1638,10 @@ int main(int argc, char *argv[])
> > 			printf("failed getting size of device/file\n");
> > 			return 1;
> > 		}
> > +		if (pt && bs < lbs) {
> > +			printf("error: bs:%d is less than logical_block_size:%d\n", bs, lbs);
> > +			return 1;
> > +		}
> 
> would it be better to replace the check/print with "bs % lbs" instead?
> since io size needs to be multiple of lbs to go through.
> 

right, will modify the check accordingly

--
Anuj Gupta


------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa62a_
Content-Type: text/plain; charset="utf-8"


------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa62a_--
