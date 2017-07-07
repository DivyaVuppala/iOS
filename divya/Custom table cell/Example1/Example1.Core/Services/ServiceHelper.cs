using System;
using System.Collections.Generic;

namespace Example1.Core.Services
{
		public class Details
		{
			public int Id{ get; set;}
			public string Name { get; set; }
		}
		public interface IDetailsService
		{
		Details CreateNewDetailService(string extra = "");
		}

		public class DetailsService : IDetailsService
		{
			#region IDetailsService implementation

		public Details CreateNewDetailService (string extra = "")
			{
				return new Details()
				{
				Name = _names[Random(_names.Count)] + extra,
					Id = RandomId()
				};
			}

			#endregion

			private readonly List<string> _names = new List<string>() { 
				"Tiddles", 
				"Amazon", 
				"Pepsi", 
				"Solomon", 
				"Butler", 
				"Snoopy", 
				"Harry", 
				"Holly", 
				"Paws", 
				"Polly", 
				"Dixie", 
				"Fern", 
				"Cousteau", 
				"Frankenstein", 
				"Bazooka", 
				"Casanova", 
				"Fudge", 
				"Comet" };

			private readonly System.Random _random = new System.Random();
			protected int Random(int count)
			{
				return _random.Next(count);
			}

			protected int RandomId()
			{
				return Random(23) + 3;
			}
		}

}

