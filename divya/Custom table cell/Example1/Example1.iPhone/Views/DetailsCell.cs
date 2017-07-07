
using System;

using Foundation;
using UIKit;
using Cirrious.MvvmCross.Binding.Touch.Views;
using Cirrious.MvvmCross.Binding.BindingContext;
using Example1.Core.Services;

namespace Example1.iPhone
{
	public partial class DetailsCell : MvxTableViewCell
	{
		public static readonly UINib Nib = UINib.FromName ("DetailsCell", NSBundle.MainBundle);
		public static readonly NSString Key = new NSString ("DetailsCell");

		public DetailsCell (IntPtr handle) : base (handle)
		{

			this.DelayBind (() =>{
				var set=this.CreateBindingSet<DetailsCell,Details> ();
				//NameLabel.TextColor = UIColor.Black;                //var imageLoader = new MvxImageViewLoader(() =>this.MainImage);
				set.Bind(NameLabel).To(name =>name.Name);
				set.Bind(IdLabel).To(id =>id.Id);
				//set.Bind(imageLoader).To(kitten =>kitten.ImageUrl);
				set.Apply();
			});

		}

		public static DetailsCell Create ()
		{
			return (DetailsCell)Nib.Instantiate (null, null) [0];
		}

		/*public override void LayoutSubviews ()
		{
			base.LayoutSubviews ();
			var data =(Details)DataContext;
			NameLabel.Text = data.Name;
			IdLabel.Text = data.Id.ToString();
		}
		*/
	}
}

