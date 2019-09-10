//
//  OGDocument+JSON.h
//  BU Eats
//
//  Created by Tanner on 9/11/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "OGDocument.h"
#import "CDMealPeriod.h"
#import "CDMeal.h"

/// This is where all the HTML scraping is done so that
/// Mantle can convert the resulting JSON into objects.
///
/// Methods have their schemas documented below.
/// A trailing question mark (?) after a key name
/// means the key may not not be present at all.
@interface OGDocument (JSON)

/// Scrapes a CDMealPeriod.
///
/// Schema for a meal period is as follows:
/// @code
/// {
///     error?: string,
///     period: CDMeal*,
///     foodStations?: FoodStation[]
/// }
/// @endcode
///
/// Schema for a food station is as follows:
/// @code
/// {
///     name: string,
///     foodItems: { name: string, calories: string, about: string, allergens: string[] }[],
///     additionalItems: string[]
/// }
/// @endcode
- (NSDictionary *)toMealPeriodJSONWithMeal:(CDMeal *)meal;

/// Scrapes an array of locations.
///
/// Schema for a location is as follows:
/// @code
/// {
///     identifier: string,
///     name: string,
///     address: string,
///     note: string,
///     open: bool,
/// }
/// @endcode
- (NSArray *)toJSONArrayOfLocations;

/// Scrapes an array of meals.
///
/// Schema for a meal is as follows:
/// @code
/// {
///     identifier: number,
///     name: string,
/// }
/// @endcode
- (NSArray *)toJSONArrayOfMeals;

@end
