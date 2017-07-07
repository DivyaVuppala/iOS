using Cirrious.MvvmCross.Binding.BindingContext;
using Cirrious.MvvmCross.Touch.Views;
using CoreGraphics;
using Foundation;
using ObjCRuntime;
using UIKit;
using Example1.Core.ViewModels;
using Cirrious.MvvmCross.Binding.Touch.Views;

namespace Example1.iPhone.Views
{
    [Register("FirstView")]
	public class FirstView : MvxTableViewController
    {
        public override void ViewDidLoad()
        {
            View = new UIView { BackgroundColor = UIColor.White };
            base.ViewDidLoad();

			if (RespondsToSelector(new Selector("edgesForExtendedLayout")))
				EdgesForExtendedLayout = UIRectEdge.None;
			TableView = new UITableView (new CGRect (10, 10, 300, 700));

			var source = new MvxSimpleTableViewSource (TableView, DetailsCell.Key, DetailsCell.Key);//DetailsCell.Key, DetailsCell.Key);
			TableView.RowHeight = 100;
			TableView.Source = source;

			var set = this.CreateBindingSet<FirstView, FirstViewModel>();
			set.Bind(source).To(vm => vm.Details);
			set.Apply();

			TableView.ReloadData();
        }

    }
}