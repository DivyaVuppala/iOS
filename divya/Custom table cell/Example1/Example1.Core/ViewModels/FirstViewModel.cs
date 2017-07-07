using Cirrious.MvvmCross.ViewModels;
using System.Collections.Generic;
using Example1.Core.Services;

namespace Example1.Core.ViewModels
{
    public class FirstViewModel 
		: MvxViewModel
    {
		public FirstViewModel(IDetailsService service)
		{
			var _newdetails = new List<Details>();
			for (var i = 0; i < 3; i++)
			{
				var newDetails = service.CreateNewDetailService (i.ToString());
				_newdetails.Add(newDetails);
			}
			Details = _newdetails;
		}

		private List<Details> _details;
		public List<Details> Details
		{
			get { return _details; }
			set { _details = value; RaisePropertyChanged(() => Details); }
		}
    }
}
