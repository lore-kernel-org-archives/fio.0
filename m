Return-Path: <zwp10758@gmail.com>
Return-Path: <zwp10758@gmail.com>
From: weiping zhang <zwp10758@gmail.com>
Date: Wed, 6 Sep 2017 18:13:05 +0800
Subject: Re: [PATCH] don't change direct I/O xfer size during initial layout
 setup
Message-ID: <20170906101305.GA39250@localhost.didichuxing.com>
References: <20170904152317.6065-1-tkusumi@tuxera.com>
 <CALjAwxhADLVViWBc2WyDsK5LOByV39f3X2Fs5qxsTC+ExBED1A@mail.gmail.com>
 <CAHndrBkUMYUG-e6dqk9NsBBt7fJkHMH2M70-v9LrQ=K-KiFhtw@mail.gmail.com>
 <CALjAwxgnm7c+64kW7Y+-e36qPg8nYR_7n-=htuL5Pb6FQUPT8g@mail.gmail.com>
 <CAHndrBn0bdfC0kT5cg7TnGE3X6=SAaxCMCf9zORvx8zOxdnObw@mail.gmail.com>
 <21362e1f-e266-9b49-ba62-6ca8d705e7c9@kernel.dk>
 <CAHndrBk6BKQW-YdBzK7=i2VFuuBKu+nT-Uj-9X0BH8w+Nq=g=w@mail.gmail.com>
 <c645b819-a5bf-1dae-cb39-caee7fd434c1@kernel.dk>
 <CALjAwxgW3GDdmVMrDrXM=8dktWZgFJ2pZ5V3Enjv+OZn6R5NRQ@mail.gmail.com>
 <185cfb09-b1f7-bab4-1991-810dce580db6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185cfb09-b1f7-bab4-1991-810dce580db6@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Sep 05, 2017 at 01:45:59PM -0600, Jens Axboe wrote:
> On 09/05/2017 01:00 PM, Sitsofe Wheeler wrote:
> > On 5 September 2017 at 15:58, Jens Axboe <axboe@kernel.dk> wrote:
> >> On 09/05/2017 08:54 AM, Tomohiro Kusumi wrote:
> >>> I think I've made three fixes over the original two commits.
> >>>
> >>> 1. non O_DIRECT dio support -> committed -> now reverted
> >>> 2. segfault on fio_memfree() -> committed -> now reverted
> >>> 3. this one
> >>>
> >>> As far as I've seen this is it.
> >>
> >> Right, just checked (and reverted) and it's 5 changes all in
> >> all for the change, not including the parent to this email,
> >> which would have made it 6 in all. The original change from Weiping
> >> clearly wasn't well tested or thought through, so it's better
> >> to just kill it all and do it cleanly from scratch instead.
> > 
> > Unfortunately it's been a problem magnetic with stacks of extra
> > conditions turning up and corner cases to stumble over (see
> > https://github.com/sitsofe/fio/commit/8fed4ccc87e39144643b1e32caddd882e6197e58
> > for yet another case that was going to need fixing).
> > 
> >> That said, I'm not even convinced we need this change. Logically
> >> it makes sense, but there's really nothing wrong with doing
> >> a buffered layout + cache kill as we have been doing since
> >> the dawn of time in fio.
> > 
> > One of the benefits was that it stopped
> > 
> > rm -f /tmp/fiofile; ./fio --loops=10 --filename /tmp/fiofile --bs=4k \
> >  --size=1M --direct=1 --name=go
> > 
> > reporting cached speeds on macOS (a platform where invalidation
> > doesn't work). The sad thing is that the change wound up slowing
> > layout right down because the I/O is potentially done in such small
> > sizes. With the problems it attracted it need a re-think if it's to
> > avoid attracting a never ending stream of workarounds.
> 
> Slowing down layout for everyone is a much larger issue (and a
> regression), whereas the lack of cache invalidation on a 2nd tier
> platform is much less interesting. Of the two, I know what I'd pick.
> 
> It'd be nice if we can get everything working nicely. Honestly, it's not
> rocket science (at all) to use O_DIRECT for layouts. The performance
> issue is the biggest hurdle, the only thing we can do there is use a
> larger block size and hope it closes enough of the gap.
> 

Hi Jens,

How about add a slight check, open a temp file with O_DIRECT but
pre-allocate using buffer io, like following:


diff --git a/filesetup.c b/filesetup.c
index b51ab35..7b86938 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -107,7 +107,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
  */
 static int extend_file(struct thread_data *td, struct fio_file *f)
 {
-	int new_layout = 0, unlink_file = 0, flags;
+	int new_layout = 0, unlink_file = 0, flags, tmp_fd;
 	unsigned long long left;
 	unsigned int bs;
 	char *b = NULL;
@@ -152,6 +152,16 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 #endif
 
 	dprint(FD_FILE, "open file %s, flags %x\n", f->file_name, flags);
+
+	if (td->o.odirect) {
+		tmp_fd = open(f->file_name, flags | OS_O_DIRECT, 0644);
+		if (tmp_fd < 0 && errno == EINVAL)
+			log_err("fio: seems like filesystem does not support " \
+				"direct=1/buffered=0\n");
+		if (tmp_fd < 0)
+			return 1;
+		close(tmp_fd);
+	}
+
 	f->fd = open(f->file_name, flags, 0644);
 	if (f->fd < 0) {
 		int err = errno;

Thanks

