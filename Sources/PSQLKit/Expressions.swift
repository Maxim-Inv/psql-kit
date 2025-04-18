// Expressions.swift
// Copyright (c) 2024 hiimtmac inc.

public typealias GENERATE_SERIES = GenerateSeriesExpression
public typealias MAX = MaxExpression
public typealias MIN = MinExpression
public typealias SUM = SumExpression
public typealias COUNT = CountExpression
public typealias AVG = AverageExpression
public typealias JSON_EXTRACT_PATH_TEXT = JsonExtractPathTextExpression
public typealias JSONB_EXTRACT_PATH_TEXT = JsonbExtractPathTextExpression
public typealias JSON_EXTRACT_PATH = JsonExtractPathExpression
public typealias JSONB_EXTRACT_PATH = JsonbExtractPathExpression
public typealias JSON_OBJECT_AGG = JsonObjectAggExpression
public typealias JSONB_OBJECT_AGG = JsonbObjectAggExpression
public typealias JSON_BUILD_OBJECT = JsonBuildObjectExpression
public typealias JSONB_BUILD_OBJECT = JsonbBuildObjectExpression

public typealias ARRAY_AGG = ArrayAggregateExpression
public typealias ARRAY_APPEND = ArrayAppendExpression
public typealias ARRAY_CAT = ArrayConcatenateExpression
public typealias ARRAY_DIMS = ArrayDimensionsExpression
public typealias ARRAY_LENGTH = ArrayLengthExpression
public typealias ARRAY_LOWER = ArrayLowerExpression
public typealias ARRAY_NDIMS = ArrayNumberDimensionsExpression
public typealias ARRAY_PREPEND = ArrayPrependExpression
public typealias ARRAY_REMOVE = ArrayRemoveExpression
public typealias ARRAY_REPLACE = ArrayReplaceExpression
public typealias ARRAY_TO_STRING = ArrayToStringExpression
public typealias ARRAY_UPPER = ArrayUpperExpression
public typealias COALESCE = CoalesceExpression
public typealias CONCAT = ConcatenateExpression

public typealias DATE_TRUNC = DateTruncExpression
public typealias DATE_PART = DatePartExpression

public typealias CROSSTAB = CrosstabExpression

public protocol Expression {}
public protocol AggregateExpression: Expression {}
